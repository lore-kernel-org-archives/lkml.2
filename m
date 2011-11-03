Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab1KCNCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:02:31 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:14811
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842Ab1KCNCa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:02:30 -0400
X-SpamScore: -13
X-BigFish: VPS-13(zz9371Kc89bh542M1432Nzz1202hzz8275bh8275dhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LU35J2-02-DX4-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: RE: [027/101] drm/radeon/kms: fix typo in r100_blit_copy
Thread-Topic: [027/101] drm/radeon/kms: fix typo in r100_blit_copy
Thread-Index: AQHMmcmQRQrl50bBfEqX9PDeA6wX+pWbHeDA
Date: Thu, 3 Nov 2011 13:01:51 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D00AFCA47F@sausexdag02.amd.com>
References: <20111102222755.GA10893@kroah.com>
 <20111102222742.153000450@clark.kroah.org>
In-Reply-To: <20111102222742.153000450@clark.kroah.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.181.250.19]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't apply.  This ended up getting reverted upstream.

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, November 02, 2011 6:26 PM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: torvalds@linux-foundation.org; akpm@linux-foundation.org;
> alan@lxorguk.ukuu.org.uk; Deucher, Alexander; Dave Airlie
> Subject: [027/101] drm/radeon/kms: fix typo in r100_blit_copy
> 
> 2.6.33-longterm review patch.  If anyone has any objections, please let us
> know.
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
> @@ -496,8 +496,8 @@ int r100_copy_blit(struct radeon_device
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


