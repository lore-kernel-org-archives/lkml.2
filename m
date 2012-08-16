Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2HPFLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:11:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35677 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2HPFLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:11:05 -0400
Date: Thu, 16 Aug 2012 02:10:56 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: koko Aborigines <7aborigines7@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add support bluetooth usb 0489:e046 Foxconn / Hon Hai
Message-ID: <20120816051056.GA25290@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	koko Aborigines <7aborigines7@gmail.com>, marcel@holtmann.org,
	padovan@profusion.mobi, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1344757304-11555-1-git-send-email-7aborigines7@gmail.com>
 <20120815044111.GG3344@joana>
 <CA+iwHK1VYJ+G-9aVgkzvAV4C3Unhyz-sqC+_SkUmPhffs1_=CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+iwHK1VYJ+G-9aVgkzvAV4C3Unhyz-sqC+_SkUmPhffs1_=CQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* koko Aborigines <7aborigines7@gmail.com> [2012-08-16 10:12:44 +0700]:

> Hi, Gustavo
> 
> i have error with your patch
> 
>  CC [M]  drivers/bluetooth/btusb.o
> drivers/bluetooth/btusb.c:113:2: error: implicit declaration of function
> ‘USB_VENDOR_AND_INTERFACE_INFO’ [-Werror=implicit-function-declaration]
> drivers/bluetooth/btusb.c:113:2: error: initializer element is not constant
> drivers/bluetooth/btusb.c:113:2: error: (near initialization for
> ‘btusb_table[22].match_flags’)

You need to apply it against the bluetooth-next tree (or linux-next).

	Gustavo
