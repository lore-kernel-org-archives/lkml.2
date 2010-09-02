Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0IBAZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 20:25:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:59847 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab0IBAZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 20:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QNlrmX3yOSepKzjm0UxKmrtYkQcgDi1l3Giv0ByAefu+OHmS+s2j3gbi1n+ZSbKPVM
         uCR3DGfbPNklKRN9ZwitTKZDfO/6xUjVP9GacmxbpuifbiIOPto4UlZZfdH852KKlSSk
         +juJg7ExU21/FgEiyPdedXf8JKRbAy2feej3Y=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
	<AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
	<alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
	<alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
	<alpine.DEB.2.00.1008310717260.4858@p34.internal.lan>
	<alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
	<alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
	<alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
Date: Wed, 1 Sep 2010 17:25:06 -0700
Message-ID: <AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
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

On Wed, Sep 1, 2010 at 2:40 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Could the lock/unlock be causing the issue?
> Again, in 2.6.34, there are no latency problems or controller resets.

Justin,

We are looking into this issue and should get back to you soon.

The lock/unlock() kernel calls were not added by me but were part of a
series of 'BKL pushdown' patches added by someone to all drivers with
an ioctl interface.  If you think those might be related to your
issue, you could try
removing those 2 lines of code and recompiling.

If you haven't already, please email you kernel .config files for both
the working kernel and non working kernel to the 3ware/LSI support
people you are in contact with.

Thanks.

-Adam
