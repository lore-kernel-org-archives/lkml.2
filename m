Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1BESRR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 13:17:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46734 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab1BESRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 13:17:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Sat, 5 Feb 2011 19:16:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201102042136.20165.rjw@sisk.pl> <4D4D4EF1.8010107@pardus.org.tr>
In-Reply-To: <4D4D4EF1.8010107@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102051916.32141.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 05, 2011, Ozan Çağlayan wrote:
> On 04.02.2011 22:36, Rafael J. Wysocki wrote:
> 
> >
> > At this point I guess it's best to open a bug entry in the kernel Bugzilla,
> > against ACPI (although ACPI may be a red herring), and put some system
> > information (ie. dmesg outputs from working kernels, if any, outputs of
> > acpidump) -- or links to where it can be found.
> 
> Well I've already filed two bugs:
> https://bugzilla.kernel.org/show_bug.cgi?id=26502
> https://bugzilla.kernel.org/show_bug.cgi?id=27412

OK

So the conclusion from this thread is that disabling cpuidle doesn't help, right?

Did you carry out the !CONFIG_NO_HZ tests?

Rafael
