Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab0LFIyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 03:54:45 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:41397 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab0LFIyo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 03:54:44 -0500
MIME-Version: 1.0
In-Reply-To: <1288631750-2218-1-git-send-email-x0095078@ti.com>
References: <Act55ohcdcwbjUYNRFK4Cj1Br4dQDQ==>
	<1288631750-2218-1-git-send-email-x0095078@ti.com>
Date: Mon, 6 Dec 2010 02:54:43 -0600
Message-ID: <AANLkTi=7ZuOPm1WiYUs+DpLwzOp8Oam-N6TdWxHrA5d=@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge - Eliminate direct manipulation of OMAP_SYSC_BASE
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: "Uribe de Leon, Armando" <x0095078@ti.com>
Cc: gregkh@suse.de, felipe.contreras@gmail.com, "Menon, Nishanth" <nm@ti.com>,
        ohad@wizery.com, "Guzman Lugo, Fernando" <fernando.lugo@ti.com>,
        "Sapiens, Rene" <rene.sapiens@ti.com>, ameya.palande@nokia.com,
        "Gomez Castellanos, Ivan" <ivan.gomez@ti.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ramos Falcon, Ernesto" <ernesto@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 12:15 PM, Uribe de Leon, Armando <x0095078@ti.com> wrote:
> Eliminates Bridge direct manipulation of OMAP_SYSC_BASE registers
>
> Signed-off-by: Armando Uribe <x0095078@ti.com>
> ---
>  drivers/staging/tidspbridge/core/dsp-clock.c       |   52
> +-------------------
>  drivers/staging/tidspbridge/core/tiomap3430.c      |    3 -
>  .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
>  .../staging/tidspbridge/include/dspbridge/drv.h    |    3 -
>  drivers/staging/tidspbridge/rmgr/drv.c             |    1 -
>  5 files changed, 2 insertions(+), 58 deletions(-)

Pushed to dspbridge.

Regards,

Omar
