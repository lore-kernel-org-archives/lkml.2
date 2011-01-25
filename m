Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1AYTjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:39:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38422 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AYTjN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:39:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>
Subject: Re: Common boot/shutdown issues with the latest 2.6.37 (Mostly Asus laptops)
Date: Tue, 25 Jan 2011 20:38:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc1+; KDE/4.4.4; x86_64; ; )
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        colin.king@canonical.com
References: <556624.21214.qm@web28409.mail.ukl.yahoo.com> <4D3DDDA4.2080202@yahoo.fr> <201101250822.48287.ozan@pardus.org.tr>
In-Reply-To: <201101250822.48287.ozan@pardus.org.tr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101252038.25113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 25, 2011, Ozan Çağlayan wrote:
> Pazartesi 24 Ocak 2011 günü (saat 22:14:28) Lionel Debroux şunları yazmıştı:
> > On 24.01.2011 10:47, Lionel Debroux wrote:
> 
> > None of nolapic, acpi=off, nolapic acpi=off enables 2.6.35.8 to boot
> > on my ASUS F3Jv-AS022P.
> > The kernel line is
> > kernel /boot/vmlinuz root=/dev/sda9 nomce vga=791 nomodeset
> > I've attached the 2.6.35.6 config.
> 
> Yes one of my reporters also tells that on 2.6.35 the problem can't be cured with nolapic
> but on 2.6.37 it helps.

Does
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ec30f343d61391ab23705e50a525da1d55395780
generally help?

Rafael
