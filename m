Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab0LGLTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:19:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46546 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0LGLTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:19:21 -0500
MIME-Version: 1.0
In-Reply-To: <20101207105620.GB23729@core.coreip.homeip.net>
References: <1291706726-8835-1-git-send-email-rydberg@euromail.se>
 <20101207091653.GA22416@core.coreip.homeip.net> <AANLkTimnSsfCG0WtDpa-qEu3N1uMOeo+CzzZ8wsaZN1v@mail.gmail.com>
 <20101207105620.GB23729@core.coreip.homeip.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 7 Dec 2010 12:19:05 +0100
Message-ID: <AANLkTinmcKgUJfs+0_E6Zke6Y0+nfMU71Z8sY_-7-0iE@mail.gmail.com>
Subject: Re: [RFC][PATCH] input: Introduce device information ioctl
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ping Cheng <pingc@wacom.com>, Chris Bagwell <chris@cnpbagwell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 11:56, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Tue, Dec 07, 2010 at 11:48:28AM +0100, Kay Sievers wrote:

>> Please don't add new ioctls which are not extensible. The ioctl should
>> carry the length or the version of the structure it asks for, so it
>> can be extended in the future.
>
> Size of ioctl data is encoded in ioctl, it can be extended easily. For
> examples take a look at how EVIOCGKEYCODE and EVIOCGSKEYCODE are handled
> in recent kernels.

Oh, how does that work? With the ioctl call, userspace has to supply
the size it expects to be returned from the kernel. How does the
kernel otherwise know how much it is allowed to copy to the user?

Kay
