Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab1CDHjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:39:11 -0500
Received: from forward1.mail.yandex.net ([77.88.46.6]:46020 "EHLO
	forward1.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab1CDHjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:39:10 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Mar 2011 02:39:10 EST
Subject: Re: [PATCH 2/2] ASoC: Constify i2c_device_id table
From: Alexander Sverdlin <subaparts@yandex.ru>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1299223323.20907.4.camel@mola>
References: <1299223098.20907.1.camel@mola>  <1299223323.20907.4.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 10:32:45 +0300
Message-ID: <1299223965.27359.2.camel@r60e>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 15:22 +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Alexander Sverdlin <subaparts@yandex.ru>
> Cc: Timur Tabi <timur@freescale.com>
> ---
>  sound/soc/codecs/cs4270.c |    2 +-
>  sound/soc/codecs/cs4271.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 

Acked-by: Alexander Sverdlin <subaparts@yandex.ru>


