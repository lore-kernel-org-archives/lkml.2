Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1AYG2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:28:36 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:52464 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1AYG2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:28:34 -0500
From: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Tue, 25 Jan 2011 08:22:48 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31.14-132-pae; KDE/4.4.5; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, rjw@sisk.pl,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D3DDDA4.2080202@yahoo.fr>
In-Reply-To: <4D3DDDA4.2080202@yahoo.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101250822.48287.ozan@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pazartesi 24 Ocak 2011 günü (saat 22:14:28) Lionel Debroux şunları yazmıştı:
> On 24.01.2011 10:47, Lionel Debroux wrote:

> None of nolapic, acpi=off, nolapic acpi=off enables 2.6.35.8 to boot
> on my ASUS F3Jv-AS022P.
> The kernel line is
> kernel /boot/vmlinuz root=/dev/sda9 nomce vga=791 nomodeset
> I've attached the 2.6.35.6 config.

Yes one of my reporters also tells that on 2.6.35 the problem can't be cured with nolapic
but on 2.6.37 it helps.



---
Ozan Çağlayan
TUBITAK/UEKAE - Pardus Linux
http://www.pardus.org.tr/eng
