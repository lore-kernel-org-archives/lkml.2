Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2G0Ngf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:36:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:28984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab2G0Nge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:36:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="178322485"
Date: Fri, 27 Jul 2012 15:36:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
        lrg@ti.com
Subject: Re: [PATCH 4/7] mfd: ab8500-core: Apply the AB8500 CODEC's
 compatible string to its MFD cell
Message-ID: <20120727133633.GQ16859@sortiz-mobl>
References: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
 <1343392734-11805-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343392734-11805-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Jul 27, 2012 at 01:38:51PM +0100, Lee Jones wrote:
> Provide a compatible string for the AB8500 CODEC to aid in
> configuration property look-up from its associated Device Tree
> node.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c |    1 +
>  1 file changed, 1 insertion(+)
Applied as well.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
