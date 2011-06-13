Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1FMJCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:02:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab1FMJCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:02:36 -0400
Date: Mon, 13 Jun 2011 11:02:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-video@atrey.karlin.mff.cuni.cz,
        xiyoulinuxkernelgroup@googlegroups.com, linux-kernel@zh-kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Nick Piggin <npiggin@kernel.dk>,
        Karsten Keil <isdn@linux-pingi.de>, Michal Marek <mmarek@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Martin Mares <mj@ucw.cz>, Harry Wei <harryxiyou@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH] Documentation:change all arch/i386 to arch/x86 in
 Documentation
In-Reply-To: <alpine.LNX.2.00.1106131055250.22872@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1106131058570.22872@pobox.suse.cz>
References: <1307942898-3728-1-git-send-email-wanlong.gao@gmail.com> <alpine.LNX.2.00.1106131055250.22872@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Jiri Kosina wrote:

> > From: Wanlong Gao <wanlong.gao@gmail.com>
> > 
> > Change all "arch/i386" to "arch/x86" in Documentaion/,
> > since the directory has changed.
> 
> I can take it.

Actually no, I will not be taking it. Simple sed doesn't work here -- some 
of the files have either obtained a different name in the meantime, or 
don't exist any more at all.

So please, next time

- be reasonable about the recepient list of your patches
- make sure that the trivially verifiable changes are really valid (and 
  even more so if sending mail to 20+ random recepients)

-- 
Jiri Kosina
SUSE Labs
