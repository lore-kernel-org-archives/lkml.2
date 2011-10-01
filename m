Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549Ab1JAOXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:23:40 -0400
Received: from nm36-vm5.bullet.mail.bf1.yahoo.com ([72.30.238.141]:41177 "HELO
	nm36-vm5.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753998Ab1JAOXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:23:36 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Oct 2011 10:23:36 EDT
X-Yahoo-Newman-Id: 454705.19248.bm@smtp219.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: DBsXhqIVM1kIQsf0DD0OwWzTMFMQSsrdVJN03bKpHDmzI9B
 6_mqqnqxaA4xBdSa.w5j_u82uSr2LV6AHCY19J_S8Ortx43I4a0_8_CiLNTO
 R7_hM0Gx0imx.ykk2Xs5W72vyxTseQ5xQKdrnWD92TUsWLxPNKG5UPkMSVrl
 8YqrQupDVM.NcRYMbDfu7KSmMr54zD0PR5oNrjRImMH_9FQTuu_qaLoxFIqJ
 YsrTDKbpNPtKzMuF7kUSb_XFI3oFqIf1RyzlKEPWnQoDGE_WXKmdKlPWAjqP
 TM.9_YQ2dGxm0UKNTSsVC8KMEsyHnBKxa2B38qhcjqrQy6WUGMygNxNF1Lw.
 ABdwTJXu2EQ9vcHBFM_q5lEiRXEJ1lbqnfvtyQaNBiT5akolNI_5x1wre3og
 eJ6Mc.zufoy6LMobw_UcPPNW2AzoqwSo6lRmYXWMbVdjuiXIXtwdBbw--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Sat, 1 Oct 2011 09:17:51 -0500
From: akwatts@ymail.com
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001141751.GA8937@zeus>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930235924.GA25176@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, many thanks for providing these helpful hints for assessing 
system integrity.

On Fri, Sep 30, 2011 at 04:59:24PM -0700, Greg KH wrote:
> The compromise of kernel.org and related machines has made it clear that
> some developers, at least, have had their systems penetrated.  As we
> seek to secure our infrastructure, it is imperative that nobody falls
> victim to the belief that it cannot happen to them.  We all need to
> check our systems for intrusions.  Here are some helpful hints as
> proposed by a number of developers on how to check to see if your Linux
> machine might be infected with something:

I understand that git repos are protected from ex-post tampering by a
rolling sha-1 hash. However, is it possible that code submissions were
faked during the intrusion window and pulled by legitimate subsystem
or system managers?

The intrusion on kernel.org has been dated as potentially weeks
before 8/28 which means many tarballs (that common users rely on more
than git) were posted after that.

Can we confirm a few things?

a) do we know have a better estimate on the date of the initial breach?
b) is there any chance that the signing key (517D0F0E) was compromised?
c) can someone with verifiably clean code (i.e. not just downloads from
   kernel.org) post checksums (md5,sha1,rmd160) for official tarball
   releases since say 3/2011 (both full kernel and patches)?

Many thanks.

~ Andy

