Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2EMBWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 21:22:35 -0400
Received: from 4607ds7-vby.0.fullrate.dk ([95.166.183.192]:33180 "EHLO
	cow.netcompartner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2EMBWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 21:22:34 -0400
From: Lars Boegild Thomsen <lth@cow.dk>
Organization: Call of the Wild BBS
To: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend
Date: Sun, 13 May 2012 09:22:10 +0800
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.7.4; x86_64; ; )
Cc: "Tian, Kevin" <kevin.tian@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Fengzhe Zhang <fengzhe.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Andreas Wallberg <andreas.wallberg@gmail.com>,
        Robert Scott <bugs@humanleg.org.uk>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com> <625BA99ED14B2D499DC4E29D8138F15063048B864D@shsmsx502.ccr.corp.intel.com> <20120512231349.GA17443@burratino>
In-Reply-To: <20120512231349.GA17443@burratino>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205130922.10945.lth@cow.dk>
X-Spam-Score: -2.9 (--)
X-Spam-Report: Spam detection software, running on the system "cow.netcompartner.com", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 the administrator of that system for details.
 Content preview:  On Sunday 13 May 2012 07:13:49 Jonathan Nieder wrote: > In
    September, Kevin Tian wrote: > >> Lars Boegild Thomsen writes[1]: > >>> After
    update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up > >>> after
    sleep. Back to latest 2.6 kernel works fine. > - passing parameters "hpet=disable
    highres=off nohz=off" helps some > people if I understand correctly, but
   I might have misunderstood.[2] [...] 
 Content analysis details:   (-2.9 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 May 2012 07:13:49 Jonathan Nieder wrote:
> In September, Kevin Tian wrote:
> >> Lars Boegild Thomsen writes[1]:
> >>> After update from 2.6 kernel to 3.0 my Idepad S10-3 will not wake up
> >>> after sleep.  Back to latest 2.6 kernel works fine.
>  - passing parameters "hpet=disable highres=off nohz=off" helps some
>    people if I understand correctly, but I might have misunderstood.[2]

I didn't notice this one before but that actually works for me.  Adding those 
kernel params and sleep works again.  I tried combinations thereof but no-go - 
all 3 required.

> I'd be interested to hear whether the same problem occurs when trying
> to suspend from the minimal initramfs environment.  (On systems like
> Debian that use initramfs-tools, that means passing the kernel command
> line parameter "break=top", booting, loading some appropriate minimal
> collection of modules --- maybe none ---, and then running
> "echo mem >/sys/power/state".  initramfs-tools(8) has details.)

And I just tried this loading no modules manually and it's the same - never 
wakes up after sleep.

//Lars...
