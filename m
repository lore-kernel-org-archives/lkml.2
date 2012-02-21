Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2BUOgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 09:36:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab2BUOgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 09:36:04 -0500
Date: Tue, 21 Feb 2012 09:35:38 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, mingo@elte.hu, davem@davemloft.net,
        ddaney.cavm@gmail.com, pjt@google.com, rth@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4][RFC] jump label: introduce default true branch
Message-ID: <20120221143538.GA2381@redhat.com>
References: <cover.1324493360.git.jbaron@redhat.com>
 <4F42CD93.2030605@zytor.com>
 <1329778301.2293.379.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329778301.2293.379.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 11:51:41PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-02-20 at 14:47 -0800, H. Peter Anvin wrote:
> > On 12/21/2011 11:09 AM, Jason Baron wrote:
> > > Hi Peter,
> > > 
> > > I've introduced a new static_branch_def_true() construct, such that the straight
> > > line path is the true branch, and we patch a jump to get to the false branch.
> > > In order to make jump_label_inc()/dec() work as 'make true'/'make false' with
> > > counting, I've had to update some of the core jump label code. This patchset also
> > > introduces: JUMP_LABEL_INIT_TRUE/FALSE, so that keys should be initialized as:
> > > 
> > > struct jump_label_key true_key = JUMP_LABEL_INIT_TRUE;
> > > 
> > >            or
> > > 
> > > struct jump_label_key false_key = JUMP_LABEL_INIT_FALSE;
> > > 
> > > I think this patch series should address the issues that came up with sched_feat()
> > > implementation.
> > > 
> > 
> > Hi,
> > 
> > Did this ever get addressed?
> 
> I actually tried to push that stuff to Ingo, he figured it all should
> have different names. Jason and Ingo went back and forth for a while and
> afaik settled on something. Jason then went off to implement, but I
> haven't yet seen a new version.
> 
> 

I'll post a patch series later today.

Thanks,

-Jason
