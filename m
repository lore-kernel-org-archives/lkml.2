Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab1AaSYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:24:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54688 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab1AaSYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:24:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Mon, 31 Jan 2011 19:24:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101311123.14704.rjw@sisk.pl> <4D468F1F.8030704@t-online.de>
In-Reply-To: <4D468F1F.8030704@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101311924.33098.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Richard Schütz wrote:
> >>>> I'll compile a kernel with CONFIG_NO_HZ to see what happens but how do I
> >>>> disable cpuidle during boot? I've checked the kernel-parameters.txt but
> >>>> there's no cpuidle related boot parameter there.
> >>>
> >>> Booting with intel_idle.max_cstate=0 should do the trick.
> >>
> >> intel_idle.max_cstate=0 causes a fallback to the acpi_idle driver. So it
> >> does not disable the C-states directly.
> >
> > What about not building the acpi_idle driver, then?
> 
> Or just use the processor.max_cstate parameter then.

As I wrote a couple of messages ago, https://lkml.org/lkml/2011/1/31/52 .

Sure, that should do the trick too.

Thanks,
Rafael
