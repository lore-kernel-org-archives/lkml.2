Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1KVM5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 07:57:12 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48990 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab1KVM5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 07:57:10 -0500
MIME-Version: 1.0
In-Reply-To: <20111122112212.GD2734@pengutronix.de>
References: <4ecb84b9.48rmEWqC3D6x18iE%marc.vertes@sigfox.com> <20111122112212.GD2734@pengutronix.de>
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Tue, 22 Nov 2011 18:26:44 +0530
Message-ID: <CA+NV+VkBXzjDWLigLyuXaHyRfvwt5d=NBczbFYt0qYnZKHn+AA@mail.gmail.com>
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Marc Vertes <marc.vertes@sigfox.com>, wim@iguana.be,
        Sebroeck@vger.kernel.org, Van@vger.kernel.org, Wim@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com, Welte@vger.kernel.org, Harald@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 4:52 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Tue, Nov 22, 2011 at 12:17:13PM +0100, Marc Vertes wrote:
>> Add a new driver for the hardware watchdog timer on VIA chipsets.
>> Tested on a Artigo A1100, VX855 chipset.
>>
>> Signed-off-by: Marc Vertes <marc.vertes@sigfox.com>
>
> New watchdog drivers should use the framework. Have a look at
> Documentation/watchdog/convert_drivers_to_kernel_api.txt for a guide. It
> is mainly removing code, though.
I will take care of this.

Thanks,
Rahul Bedarkar
>
> Thanks,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAk7LheQACgkQD27XaX1/VRutYACdEU7AXPGKVZ9fV6SaT2B010iK
> LhAAoMBk4btczZxmA/0iXTLQQwqq0Jqt
> =bziw
> -----END PGP SIGNATURE-----
>
>
