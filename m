Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2BTWvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:51:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52525 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab2BTWvx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:51:53 -0500
Message-ID: <1329778301.2293.379.camel@twins>
Subject: Re: [PATCH 0/4][RFC] jump label: introduce default true branch
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, mingo@elte.hu, davem@davemloft.net,
        ddaney.cavm@gmail.com, pjt@google.com, rth@redhat.com,
        linux-kernel@vger.kernel.org
Date: Mon, 20 Feb 2012 23:51:41 +0100
In-Reply-To: <4F42CD93.2030605@zytor.com>
References: <cover.1324493360.git.jbaron@redhat.com>
	 <4F42CD93.2030605@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 14:47 -0800, H. Peter Anvin wrote:
> On 12/21/2011 11:09 AM, Jason Baron wrote:
> > Hi Peter,
> > 
> > I've introduced a new static_branch_def_true() construct, such that the straight
> > line path is the true branch, and we patch a jump to get to the false branch.
> > In order to make jump_label_inc()/dec() work as 'make true'/'make false' with
> > counting, I've had to update some of the core jump label code. This patchset also
> > introduces: JUMP_LABEL_INIT_TRUE/FALSE, so that keys should be initialized as:
> > 
> > struct jump_label_key true_key = JUMP_LABEL_INIT_TRUE;
> > 
> >            or
> > 
> > struct jump_label_key false_key = JUMP_LABEL_INIT_FALSE;
> > 
> > I think this patch series should address the issues that came up with sched_feat()
> > implementation.
> > 
> 
> Hi,
> 
> Did this ever get addressed?

I actually tried to push that stuff to Ingo, he figured it all should
have different names. Jason and Ingo went back and forth for a while and
afaik settled on something. Jason then went off to implement, but I
haven't yet seen a new version.


