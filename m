Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1AGUSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:18:45 -0500
Received: from mirapoint21.brutele.be ([212.68.199.158]:40659 "EHLO
	mirapoint21.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab1AGUSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:18:44 -0500
Message-ID: <4D277520.80006@tvcablenet.be>
Date: Fri, 07 Jan 2011 21:18:40 +0100
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101219 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [132/152] drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
References: <20110106002500.GA3172@kroah.com> <20110106002309.150359580@clark.site>
In-Reply-To: <20110106002309.150359580@clark.site>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint21.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B020A.4D277521.015B,ss=1,fgs=0,
	ip=192.168.1.2,
	so=2010-02-10 23:06:36,
	dmn=2006-10-18 21:42:11,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/01/11 01:23, Greg KH a écrit :
> 2.6.36-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Chris Wilson <chris@chris-wilson.co.uk>
> 
> commit 448f53a1ede54eb854d036abf54573281412d650 upstream.
> 
> Fixes the lack of output on the LVDS panel of the Lenovo U160.
> 
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31596
> Reported-and-tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/gpu/drm/i915/intel_bios.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/gpu/drm/i915/intel_bios.c
> +++ b/drivers/gpu/drm/i915/intel_bios.c
> @@ -276,7 +276,7 @@ parse_general_features(struct drm_i915_p
>  					general->ssc_freq ? 66 : 48;
>  			else if (IS_IRONLAKE(dev_priv->dev) || IS_GEN6(dev))
>  				dev_priv->lvds_ssc_freq =
> -					general->ssc_freq ? 100 : 120;
> +					general->ssc_freq ? 120 : 100;
>  			else
>  				dev_priv->lvds_ssc_freq =
>  					general->ssc_freq ? 100 : 96;
> 
> 

This commit gives a black screen on many computers and has been reverted
between 2.6.37-rc8 and 2.6.37. Why has this been added to this review ?

Thanks,
François Valenduc
