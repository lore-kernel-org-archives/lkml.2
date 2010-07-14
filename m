Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab0GNOZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:25:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab0GNOZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:25:41 -0400
Date: Wed, 14 Jul 2010 16:25:21 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
Message-ID: <20100714142521.GA19289@fancy-poultry.org>
Mail-Followup-To: Christoph Lameter <cl@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
	linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
References: <20100709190706.938177313@quilx.com>
 <20100710195621.GA13720@fancy-poultry.org>
 <alpine.DEB.2.00.1007121010420.14328@router.home>
 <20100712163900.GA8513@fancy-poultry.org>
 <alpine.DEB.2.00.1007121156160.18621@router.home>
 <20100713135650.GA6444@fancy-poultry.org>
 <alpine.DEB.2.00.1007132055470.14067@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1007132055470.14067@router.home>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:lW4MeLbWDA1hWjbETui0fbSCBR2rdWqkjD0tyHos9I3
 r+DZepuYUdqoppApD1qJUjPhSplfQFMeG9ICuRrpN3MN0gwIGm
 y+alszvaHvtTKHMvMSxmesEhkERoEChwnUhmk+XItGx5LB5yYj
 pzUiGnZ7K14LNy3Xmhi6ireKKt5NcnBoE5Bb6Rcfb2oQ7PK6wJ
 a2jUvX7eaVgrnhgRxADNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.2010, Christoph Lameter wrote: 

> I dont see anything in there at first glance that would cause slub to
> increase its percpu usage. This is straight upstream?

Yes ,it's plain vanilla 2.6.35-rc4/-rc5 from kernel.org.

> Try to just comment out the BUILD_BUG_ON.

I first bumped it up to 24k, but that was obviously not enough, so I
commented out the BUILD_BUG_ON which triggers the build error. Now It builds
fine, and I'll do some testing.

Thanks,
Heinz.
