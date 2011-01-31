Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1AaKOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:14:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51449 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab1AaKOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:14:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Mon, 31 Jan 2011 11:14:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101311050.49722.rjw@sisk.pl> <4D4688DD.6030502@pardus.org.tr>
In-Reply-To: <4D4688DD.6030502@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101311114.11935.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Ozan Çağlayan wrote:
> On 31.01.2011 11:50, Rafael J. Wysocki wrote:
> > On Monday, January 31, 2011, Ozan Çağlayan wrote:
> >> On 31.01.2011 00:48, Rafael J. Wysocki wrote:
> >>
> >>> Does booting with "nolapic" help on all of the affected systems?
> >>>
> >>> Also, does disabling the CPUidle during boot help?
> >>>
> >>> Finally, is the problem reproducible with CONFIG_NO_HZ unset?
> >>
> >> Well on two machines, nolapic cures the boot hang and on one machine it
> >> cures the random shutdown hangs.
> >>
> >> I'll compile a kernel with CONFIG_NO_HZ to see what happens but how do I
> >> disable cpuidle during boot? I've checked the kernel-parameters.txt but
> >> there's no cpuidle related boot parameter there.
> >
> > Booting with intel_idle.max_cstate=0 should do the trick.
> 
> Okay but on Asus X61S idle fallbacks to cpuidle:
> 
> intel_idle: MWAIT substates: 0x3122220
> intel_idle: does not run on family 6 model 23
> 
> so forcing max_cstate to 0 will turn off the cpuidle on those machines too?

In those cases you can use processor.max_cstate=0 I think.

Rafael
