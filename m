Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1FLRsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 13:48:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1FLRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 13:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rATXXmvfm5sRTxyygh50JahqyPCaP+bhlu9frxSf1BGvWqCoCdlFAZefheitLHFX+d
         dJn+Y0hm7fX+vlyD6hyaGuGhKdqxfPjPV0lZRaUl+aY1TxCYp2h98XADt3ZthbQ/KAtz
         OhTqmA40yHjDP1dX5XQY9OQajiihq250zvIZc=
MIME-Version: 1.0
In-Reply-To: <1307875953.1859.6.camel@Tux>
References: <1307875953.1859.6.camel@Tux>
Date: Sun, 12 Jun 2011 19:48:10 +0200
Message-ID: <BANLkTimXALxHwNMSODXujT4pT-C+m3rcaQ@mail.gmail.com>
Subject: Re: [PATCH] efifb: Fix call to wrong unregister function
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: "wanlong.gao" <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

2011/6/12 wanlong.gao <wanlong.gao@gmail.com>:
> <snip>
>
> Hi Maarten:
> It registered efifb_device but try to unregistered efifb_driver,
> so I think you should fix it like this?
Ah yes, that seems to be the correct one, platform_driver_register was
removed. Not 100% sure if acked by or signed-off-by is appropriate
here.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>

~Maarten
