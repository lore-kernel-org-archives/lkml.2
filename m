Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1ENJur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 05:50:47 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:43555 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1ENJuq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 05:50:46 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Marcin =?utf-8?q?Ga=C5=82czy=C5=84ski?= <marcin@galczynski.pl>
Subject: Re: USB driver "option" proposed patch to support Huawei E353 hardware
Date: Sat, 14 May 2011 11:52:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <BAD23DF0CF2645B1A237F4CA7D0B6C70@int.nthmedia.pl>
In-Reply-To: <BAD23DF0CF2645B1A237F4CA7D0B6C70@int.nthmedia.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105141152.35272.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 14. Mai 2011, 02:44:10 schrieb Marcin Gałczyński:
> Hi,
> 
> I am sharing patch to the devices/usb/serial/option.c. This allows operation 
> of Huawei E353 broadband modem using the “option” driver. The patch simply 
> adds new constant with proper product ID and an entry to usb_device_id. I 
> worked on the fresh driver file downloaded from GIT. Tested on Dell inspiron 
> 1764 (i3 core cpu) and brand new Huawei E353 modem, Fedora 15 beta.
> 
> Looking at the type of change, i doubt it has potential to introduce 
> problems in other parts of kernel or the driver itself.
> 
> I am not an active kernel developer, thus i would not be joining the list... 
> for now. If You’d like to reach me, please respond directly.

Hi,

the patch looks good, but please resend it to linux-usb@vger.kernel.org
and add a Signed-off-by: line with your name and mail.

	Regards
		Oliver
