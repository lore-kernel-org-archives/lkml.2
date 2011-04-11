Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1DKSSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 14:18:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61559 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1DKSS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 14:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=T3J+hT7rD7+IU9XVzyA4Pa85tYDJc8r657XxnK8lE7nMGXgU0dvf/bCaqs3r2LT887
         L11YkKnOIhSHbezwKIUZQqoXil9mInbU6TU4urS0TB7HDljEPAWV/s7if7DWm9SgsqM3
         oiH3eherLFUDDuSIe7k/CqE/wMJllz/apL3MQ=
Message-ID: <4DA345EF.6050408@gmail.com>
Date: Mon, 11 Apr 2011 20:18:23 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Luis Correia <luis.f.correia@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, gwingerde@gmail.com, ben@decadent.org.uk,
        users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
        Shiang Tu <shiang_tu@ralinktech.com>
Subject: Re: [PATCH] rt2800pci: rt2800usb: Firmware update
References: <1302532043-22934-1-git-send-email-Larry.Finger@lwfinger.net> <4DA33F3A.6090707@gmail.com> <BANLkTinKuQ7i20FxmDCT1cRMPvOxM0aygQ@mail.gmail.com>
In-Reply-To: <BANLkTinKuQ7i20FxmDCT1cRMPvOxM0aygQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2011 07:55 PM, Luis Correia wrote:

> the rt2870.bin should support all USB rt2800 based chipsets with
> several firmware blocks concatenated inside the file.
> same goes for rt2860, which support all PCI rt2800 based chipsets with
> several firmware blocks concatenated inside the file.
>
> we know that this is confusing, we've had to live with it for a loooong time.

They are used by staging drivers.

Even if staging drivers are deleted, there are still a lot of old
kernels running out there with staging drivers. And those kernels
need these files (rt3070.bin rt3071.bin rt3090.bin)

A link is a easy way to maintain retrocompatibility without disturb
the guys running old kernels.
