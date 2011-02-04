Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1BDGuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 01:50:17 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:55073 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab1BDGuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 01:50:11 -0500
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Fri, 4 Feb 2011 08:44:05 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-132-pae; KDE/4.4.5; i686; ; )
Cc: Richard =?utf-8?q?Sch=C3=BCtz?= <r.schtz@t-online.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D4B2883.4020701@pardus.org.tr> <201102032351.31307.rjw@sisk.pl>
In-Reply-To: <201102032351.31307.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102040844.05490.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cuma 04 Şubat 2011 günü (saat 00:51:31) Rafael J. Wysocki şunları yazmıştı:

> Hmm.  Are those boxes uniprocessor running SMP kernels?

The kernel is SMP.

ASUS X61S is 
 CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz stepping 0a

F50SV has 2 CPU's too according to dmesg:
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] I/O APIC #2 Version 20 at 0xFEC00000.
[    0.000000] IOAPIC[0]: apic_id 2, version 20, address 0xfec00000, GSI 0-23
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs

ASUS N51JQ (occasional shutdown hang) has:
CPU0: Intel(R) Core(TM) i7 CPU       Q 740  @ 1.73GHz stepping 05
[    0.132435] Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
[    0.768809] Brought up 8 CPUs


---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
