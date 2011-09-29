Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab1I2Cc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:32:28 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:12265
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755280Ab1I2Cc0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:32:26 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz9371Kc89bh542M1432Nzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LS9J0Z-01-4E1-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
CC: "stable-review@kernel.org" <stable-review@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dave Airlie <airlied@redhat.com>
Date: Wed, 28 Sep 2011 21:31:47 -0500
Subject: RE: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
Thread-Topic: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
Thread-Index: Acx+MDHNswKCf1t4Q/S9a2TzlRWZ/QAH6NdA
Message-ID: <82951087A1ED9648A152812B736362500A8F294274@sausexmbp02.amd.com>
References: <20110928220225.GA27128@kroah.com>
 <20110928220139.453112165@clark.kroah.org>
In-Reply-To: <20110928220139.453112165@clark.kroah.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't apply this to stable.  The patch ended up being in error.

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, September 28, 2011 6:02 PM
> To: linux-kernel@vger.kernel.org; stable@kernel.org
> Cc: stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-
> foundation.org; alan@lxorguk.ukuu.org.uk; Deucher, Alexander; Dave Airlie
> Subject: [134/244] drm/radeon/kms: fix typo in r100_blit_copy
> 
> 3.0-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Alex Deucher <alexander.deucher@amd.com>
> 
> commit 18b4fada275dd2b6dd9db904ddf70fe39e272222 upstream.
> 
> cur_pages is the number of pages per loop iteration.
> 
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  drivers/gpu/drm/radeon/r100.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/gpu/drm/radeon/r100.c
> +++ b/drivers/gpu/drm/radeon/r100.c
> @@ -773,8 +773,8 @@ int r100_copy_blit(struct radeon_device
>  		radeon_ring_write(rdev, (0x1fff) | (0x1fff << 16));
>  		radeon_ring_write(rdev, 0);
>  		radeon_ring_write(rdev, (0x1fff) | (0x1fff << 16));
> -		radeon_ring_write(rdev, num_pages);
> -		radeon_ring_write(rdev, num_pages);
> +		radeon_ring_write(rdev, cur_pages);
> +		radeon_ring_write(rdev, cur_pages);
>  		radeon_ring_write(rdev, cur_pages | (stride_pixels << 16));
>  	}
>  	radeon_ring_write(rdev, PACKET0(RADEON_DSTCACHE_CTLSTAT,
> 0));
> 
> 


