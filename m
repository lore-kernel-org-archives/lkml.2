Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1AaUmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:42:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1AaUmv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:42:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Mon, 31 Jan 2011 21:42:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <201101312012.42393.rjw@sisk.pl> <4D471D2F.7010008@pardus.org.tr>
In-Reply-To: <4D471D2F.7010008@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101312142.37773.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Ozan Çağlayan wrote:
> On 31.01.2011 21:12, Rafael J. Wysocki wrote:
> 
> > Booting with maxcpus=0 also disables the I/O APIC, which probably is a bit too
> > much, but let's see what happens in that case.
> 
> Well the only-booting-with-nolapic one doesn't boot with maxcpus=0. Pff, 
> are there any compile-time(Kconfig) or runtime parameters related to 
> debugging various subsystems that you'll suggest which will show where 
> the boot hangs? That way we can maybe pinpoint the issue to a specific 
> function call.

Booting with initcall_debug causes all of the initcalls to be shown (start,
finish and duration), so it may allow you to find the culprit if you can
collect the messages.

Rafael
