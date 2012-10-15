Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2JORwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:52:53 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47660 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab2JORwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:52:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, powernow-k8: Remove usage of smp_processor_id() in preemptible code
Date: Mon, 15 Oct 2012 19:56:33 +0200
Message-ID: <2671294.5qjGox1KcF@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20121015084011.GA5000@liondog.tnic>
References: <20121009193844.GC7724@alberich> <1395148.DypXQr3MdC@vostro.rjw.lan> <20121015084011.GA5000@liondog.tnic>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 of October 2012 10:40:11 Borislav Petkov wrote:
> On Mon, Oct 15, 2012 at 07:50:13AM +0200, Rafael J. Wysocki wrote:
> > Well, please don't tag patches for -stable, because -stable doesn't
> > take _patches_.
> 
> Really, I didn't know that?! :-)
> 
> > It takes commits from the Linus' tree and backports them and that's
> > maintainer's job to tag them for -stable, not yours.
> 
> You're not serious, right? This is not the case in at least 50% of the
> cases.
> 
> And this is OK because maintainers don't always know whether the patch
> should be tagged for stable. So yes, people should add the stable tag
> and yes, committers still have a veto over it.
> 
> And yes, Andreas and I *know* how stable patches get applied, thank you
> very much.

I didn't say you didn't know that.

> [ … ]
> 
> > Yes, they do, but that means it doesn't make sense to send them stuff
> > before it's been merged, right?
> 
> Ok, I get it, you don't want people to send patches to stable@vger
> *before* they've hit mainline.
> 
> Nothing in <Documentation/stable_kernel_rules.txt> states that
> stable@vger shouldn't get CCed on submissions unless the patch is
> upstream and besides, stable@vger gets CCed in a lot of discussions
> anyway so there's other traffic just the same.
> 
> Bottomline: If you think people shouldn't spam stable@vger, then tough
> luck - I don't think you can stop people from accidentally/due to the
> automated nature of the process, CC stable. Even if it said so in the
> above doc file.
> 
> As a result, stable maintainers simply rely on scripts which verify the
> patch is actually upstream before applying it to stable.

Well, perhaps I shouldn't care too, then. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
