Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab0L1Owu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 09:52:50 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50437 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0L1Owt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 09:52:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hcMMFs0rzCelHyyk/5e0ZOExDYxi65+/6zeSipcVj9EgDzz0PxYDVSM6I2eb6Mag59
         OcWztleY6iRtfeaBjy0iCKmVKX3kV2bukKGt4zSo163RzfHzBLkVCSc0+97Jkix51MKq
         mFIBVKIRpzAX1+/MgORoK513VvTpEtIYErnNs=
MIME-Version: 1.0
In-Reply-To: <20101222233821.GA20893@alchark-u3s>
References: <AANLkTikAWjK7ACyt=LedhyyrhsCk1WCiyWz182CXMe9C@mail.gmail.com>
	<4D0FE546.7050302@bluewatersys.com>
	<AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com>
	<4D1011CF.9080800@bluewatersys.com>
	<AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com>
	<4D110269.9030805@bluewatersys.com>
	<20101222211815.GA31054@alchark-u3s>
	<4D12730B.2030909@bluewatersys.com>
	<20101222222501.GA32693@alchark-u3s>
	<4D1282DA.4020804@bluewatersys.com>
	<20101222233821.GA20893@alchark-u3s>
Date: Tue, 28 Dec 2010 17:52:45 +0300
Message-ID: <AANLkTik1tcL_ABdnq5r=MCxmLJtdP0nhOzA8irP1n0CC@mail.gmail.com>
Subject: Re: [PATCH 1/6 v12] ARM: Add basic architecture support for
 VIA/WonderMedia 85xx SoC's
From: Alexey Charkov <alchark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alexey Charkov <alchark@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/23 Alexey Charkov <alchark@gmail.com>:
> This adds support for the family of Systems-on-Chip produced initially
> by VIA and now its subsidiary WonderMedia that have recently become
> widespread in lower-end Chinese ARM-based tablets and netbooks.
>
> Support is included for both VT8500 and WM8505, selectable by a
> configuration switch at kernel build time.
>
> Included are basic machine initialization files, register and
> interrupt definitions, support for the on-chip interrupt controller,
> high-precision OS timer, GPIO lines, necessary macros for early debug,
> pulse-width-modulated outputs control, as well as platform device
> configurations for the specific drivers implemented elsewhere.
>
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

Russell, will you take this for .38? Please note that the last
revision of this patch was also submitted to the ARM Linux patch
tracking system:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6597/1

Best regards,
Alexey
