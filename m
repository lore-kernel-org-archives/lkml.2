Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2IRFKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 01:10:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58658 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2IRFK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 01:10:28 -0400
MIME-Version: 1.0
In-Reply-To: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
References: <1344429020-27616-1-git-send-email-prabhakar.lad@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 18 Sep 2012 10:40:07 +0530
Message-ID: <CA+V-a8t2H_1xJb4MCfzSzHtrjTbq7HFNjuWtgtwWERS_3qZH1Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Replace the obsolete preset API by timings API
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sekhar Nori <nsekhar@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Prabhakar Lad <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro/Sekhar

On Wed, Aug 8, 2012 at 6:00 PM, Prabhakar Lad <prabhakar.lad@ti.com> wrote:
> This first patch replaces the obsolete preset API by timings
> API for davinci VPBE, appropriate chnages in machine file for
> dm644x in which VPBE is enabled. And the second patch adds support for
> timings API for ths7303 driver. Sending them as s series
> since VPBE uses the ths7303 driver.
>
> Hans Verkuil (1):
>   dm644x: replace the obsolete preset API by the timings API.
>
> Manjunath Hadli (1):
>   ths7303: enable THS7303 for HD modes
>
Can you pull this patchset ? Please inform me if anything is
needed from my side.

Regards,
--Prabhakar

>  arch/arm/mach-davinci/board-dm644x-evm.c   |   15 ++--
>  arch/arm/mach-davinci/dm644x.c             |   17 +---
>  drivers/media/video/davinci/vpbe.c         |  110 ++++++++++++----------------
>  drivers/media/video/davinci/vpbe_display.c |   60 +++++++--------
>  drivers/media/video/davinci/vpbe_venc.c    |   25 +++---
>  drivers/media/video/ths7303.c              |  107 +++++++++++++++++++++++----
>  include/media/davinci/vpbe.h               |   14 ++--
>  include/media/davinci/vpbe_types.h         |    8 +--
>  include/media/davinci/vpbe_venc.h          |    2 +-
>  9 files changed, 202 insertions(+), 156 deletions(-)
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
