Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab0H0Q3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 12:29:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49561 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0H0Q3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 12:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bnsdICmG6Wi0phq9eVEVCG4zSKX5vCeL448WtsX1WP97fvw53pig4XEV8N3ZhmVJlH
         XpqH5P7HVsfdLLsaEteApFbzPkxUB7dkQyHwciLOGLLXAoD51m22CosMbWT/pxRCqd1w
         hiiCf2DQCnt0mqxv4MJK34rrfI84DepMqpjSM=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
Date: Fri, 27 Aug 2010 09:29:42 -0700
Message-ID: <AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
Subject: Re: 3w-9xxx: scsi0: WARNING: (0x06:0x0037): Character ioctl (0x108)
 timed out, resetting card.
From: adam radford <aradford@gmail.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 6:12 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Aug 24 09:14:04 p34 kernel: [247295.662461] 3w-9xxx: scsi0: WARNING:
> (0x06:0x0037): Character ioctl (0x108) timed out, resetting card.

Justin,

This just means the firmware didn't complete an ioctl in 60 seconds.

Can try changing this define in 3w-9xxx.h:

#define TW_IOCTL_CHRDEV_TIMEOUT               60 /* 60 seconds */

to 90 or 120 seconds to see if that fixes your issue?

Thanks,

-Adam
