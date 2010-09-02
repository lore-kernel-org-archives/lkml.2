Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0IBXed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 19:34:33 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39906 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0IBXea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 19:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MhqBae2purYB32Im+8J+wI/kflW/I5Tt4OzgwghSR7hIppPthxgtUdE0UnOfkgFkGV
         YHtse9jk+kyOZZlE3shlJguKeB08xg2mTy3J+c5IQk5mGcsLNrLWxWKlvaBRVbcjLk/e
         ikS8iMVOWY+6w3VxbS2gmN0nEXx1lugqCFQ+s=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1009021818040.3149@p34.internal.lan>
References: <alpine.DEB.2.00.1008270907110.5274@p34.internal.lan>
	<AANLkTik0BSJC5DJtVNw-MA9cuoAEUrw-M1Dn4XaF99u4@mail.gmail.com>
	<alpine.DEB.2.00.1008271306100.24692@p34.internal.lan>
	<alpine.DEB.2.00.1008291137560.5384@p34.internal.lan>
	<alpine.DEB.2.00.1008310717260.4858@p34.internal.lan>
	<alpine.DEB.2.00.1008310732120.5156@p34.internal.lan>
	<alpine.DEB.2.00.1008310820350.19249@p34.internal.lan>
	<alpine.DEB.2.00.1009010536070.14332@p34.internal.lan>
	<AANLkTi=SO1nZbFySAs8_+TmCZcKBPihN6xrZfJihBnXG@mail.gmail.com>
	<alpine.DEB.2.00.1009020540500.22317@p34.internal.lan>
	<alpine.DEB.2.00.1009021025190.16817@p34.internal.lan>
	<alpine.DEB.2.00.1009021818040.3149@p34.internal.lan>
Date: Thu, 2 Sep 2010 16:34:28 -0700
Message-ID: <AANLkTi=8jU7gKVDcngZDv6MBfPSax=sRz2ZT9hvCEQd0@mail.gmail.com>
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

On Thu, Sep 2, 2010 at 3:19 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Any recommendations on how to capture the freezing between the two kernels?
> Which debug method would be best?
> Does anyone else experience high wait times under 2.6.35 that uses 3ware
> cards?
>
> I tested under another host with 2.6.35 (software raid only) and it did not
> have any issues..
>

Justin,

We are trying to duplicate your issue.  Please stay in touch with the
3ware/LSI support person you are in touch with.

Thanks,

-Adam
