Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab0E0EDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:03:47 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:45443 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab0E0EDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:03:46 -0400
Date: Thu, 27 May 2010 07:03:29 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] fbdev: fix frame buffer devices menu
Message-ID: <20100527040329.GA14841@jasper.tkos.co.il>
References: <1274896477-6832-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1274896477-6832-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 02:54:37PM -0300, Thadeu Lima de Souza Cascardo wrote:
> Commit f601441916d1e19291d0b4f044b4a7551e2924d0 has inserted the symbol
> HAVE_FB_IMX, which does not depend on FB after the menuconfig FB. This
> breaks the menu, presenting most of the drivers outside of it, when
> using menuconfig.
> 
> Moving the symbol to the start of the file, just like HAVE_FB_ATMEL,
> fixes the problem without breaking it for iMX25 configurations (tested
> with ARCH=arm, no build).
> 
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Acked-by: Baruch Siach <baruch@tkos.co.il>

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
