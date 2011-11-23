Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1KWNWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:22:05 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44226 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145Ab1KWNWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:22:03 -0500
Date: Wed, 23 Nov 2011 18:50:51 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, mailsrikar@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v7 3.2-rc2 0/30] uprobes patchset with perf probe
 support
Message-ID: <20111123132051.GA23497@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
 <20111122050330.GA24807@linux.vnet.ibm.com>
 <20111123014945.5e6cfbf57f7664b3bc1ee2e3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111123014945.5e6cfbf57f7664b3bc1ee2e3@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112313-5930-0000-0000-0000024C9C34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen, 

> > > uprobes git is hosted at git://github.com/srikard/linux.git
> > > with branch inode_uprobes_v32rc2.
> >
> > Given that uprobes has been reviewed several times on LKML and all
> > comments till now have been addressed, can we push uprobes into either
> > -tip or -next. This will help people to test and give more feedback and
> > also provide a way for it to be pushed into 3.3. This also helps in
> > resolving and pushing fixes faster.
> 
> OK, I have added that to linux-next with you as the contact,

Thanks a lot for adding uprobes to linux-next.

I am already getting feedback on things to improve.

> 
> > If you have concerns, can you please voice them?
> 
> You should tidy up the commit messages (they almost all have really bad
> short descriptions) and make sure that the authorship is correct in all
> cases.
> 

I have relooked at the commit messages. 
Have also resolve Dan Carpenter's comments on git log --oneline 
not showing properly.

> Also, I would prefer a less version specific branch name (like "for-next"
> or something) that way you won't have to keep asking me to change it over
> time.  If there is any way you can host this on kernel.org, that will
> make the merging into Linus' tree a bit smoother.


I have created a for-next branch at git://github.com/srikard/linux.git.
My kernel.org account isnt re-activated yet because I still need to
complete key-signing. I will try to get that done at the earliest.
Till then, I would have to host on github.



Please do let me know if there is anything that I have missed out.
-- 
Thanks and Regards
Srikar

