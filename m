Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab0KXIht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:37:49 -0500
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50342 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752291Ab0KXIhs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <1290583400.20639.3.camel@mola>
References: <1290583248.20639.1.camel@mola> <1290583400.20639.3.camel@mola>
From: "Varadarajan, Charulatha" <charu@ti.com>
Date: Wed, 24 Nov 2010 14:07:06 +0530
Message-ID: <AANLkTimJ-f=MRBqKDQckHdJXBaV15f7b_KKeA8rguQWp@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: Fix resource reclaim for osk5912
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arun KS <arunks@mistralsolutions.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 12:53, Axel Lin <axel.lin@gmail.com> wrote:

Add Patch description.

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/omap/osk5912.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/sound/soc/omap/osk5912.c b/sound/soc/omap/osk5912.c
> index 18d053d..7e75e77 100644
> --- a/sound/soc/omap/osk5912.c
> +++ b/sound/soc/omap/osk5912.c

<<snip>>
