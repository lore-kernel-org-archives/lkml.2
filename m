Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1FBTcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:32:21 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:33317 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1FBTcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:32:20 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: Re: [2.6.39] crash in acm_ctrl_msg+0x16/0x59
Date: Thu, 2 Jun 2011 21:34:29 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <4DE25252.7050503@gmail.com> <201106010934.45691.oneukum@suse.de> <4DE67F36.8060600@gmail.com>
In-Reply-To: <4DE67F36.8060600@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106022134.29647.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 1. Juni 2011, 20:04:38 schrieb Riccardo Magliocchetti:
> Il 01/06/2011 09:34, Oliver Neukum ha scritto:
> > Am Mittwoch, 1. Juni 2011, 09:05:44 schrieb Riccardo Magliocchetti:
> >>>> Here's the lsusb -v
> >>>
> >>> There is something strange going on. This is a cdc-ether device.
> >>> Are you using any additional patches?
> >>
> >> I'm using a vanilla 2.6.39. I can get only lsusb when the phone is
> >> booted and in that case it is recgnized as cdc-ether.
> >>
> >> This is what i got when i attached the phone switched off like when i
> >> got the crash:
> >
> > Then please post lsusb -v of that state. This is a log of a connection
> > going wrong due to a bad cable or interference. Does that always happen?
> 
> yes it does always happen because (i think) the device hangs, so lsusb 
> does not show the device.

Hm. Now I am completely disoriented. Could you please explain in which modi
the device can be connected and which of them work?

	TIA
		Oliver

