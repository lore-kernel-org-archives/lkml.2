Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab0CRVwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 17:52:25 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59359 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab0CRVwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 17:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <880c1631003181451r7669428ctee7adc867979bc25@mail.gmail.com>
References: <201003182246.54889.linux@rainbow-software.org>
	 <880c1631003181451r7669428ctee7adc867979bc25@mail.gmail.com>
Date: Thu, 18 Mar 2010 21:52:23 +0000
Message-ID: <880c1631003181452w4b8a500br6aa7a5388e60b5c@mail.gmail.com>
Subject: [rt2x00-users] rt2500usb broken since 2.6.29
From: Luis Correia <buga@loide.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 18, 2010 at 21:46, Ondrej Zary <linux@rainbow-software.org> wrote:
>
> Hello,
> rt2500usb is broken since kernel 2.6.29. It has been discussed before but
> never solved:
> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
> https://bugzilla.redhat.com/show_bug.cgi?id=484888
>
> I have Asus WL-167G and it really does not work. Scanning works, association
> too but no packets can be sent (looks like receive works because tcpdump
> shows packets from other machines). DHCP fails (No DHCPOFFERS received).
>
> The problem is caused by this patch:
>
> rt2x00: Implement HW encryption (rt2500usb)
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dddfb478b26e29a2b47f655ec219e743b8111015
>
> Removing it from 2.6.29 restores the functionality.
>
> --
> Ondrej Zary
>

you can prevent hardware encryption by supplying "nohwcrypt=1" to the driver.
(modinfo rt2500usb)

Luis Correia
rt2x00 project admin
