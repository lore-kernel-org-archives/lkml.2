Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab1KQNsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:48:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757594Ab1KQNsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:48:30 -0500
Date: Thu, 17 Nov 2011 15:47:19 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
Message-ID: <20111117134719.GE16853@redhat.com>
References: <20111117123029.GB16853@redhat.com>
 <1321534159.27735.33.camel@twins>
 <20111117132939.GB2215@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111117132939.GB2215@x1.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 02:29:39PM +0100, Borislav Petkov wrote:
> On Thu, Nov 17, 2011 at 01:49:19PM +0100, Peter Zijlstra wrote:
> > Ideally we'd fix text_poke to not use stop_machine() we know how to,
> > but we haven't had the green light from Intel/AMD yet.
> 
> We talked about it briefly with hpa and tglx at KS. AFAICR, there's a
> patchset in the works...
> 
I am eager to test it. If someone has something testable send it my way :)

--
			Gleb.
