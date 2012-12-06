Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2LFSWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:22:01 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab2LFSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:22:00 -0500
Date: Thu, 6 Dec 2012 19:21:53 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Lekensteyn <lekensteyn@gmail.com>, Heinz Diehl <htd@fritha.org>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>
Subject: Re: i915 freakout with latest 3.7 git
Message-ID: <20121206182153.GA2595@fancy-poultry.org>
References: <20121203173951.GA25384@fancy-poultry.org>
 <1498848.rM1KKK5er8@al>
 <20121204210845.GA2092@fritha.org>
 <2102240.hdkK7C4k4g@al>
 <CAKMK7uEaT1H0DUszYqxbp_8WdLWs2quQbSJVqir0eAibYKvN+A@mail.gmail.com>
 <20121206093544.GA22915@fancy-poultry.org>
 <20121206162402.GA2042@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121206162402.GA2042@fancy-poultry.org>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+67 (d414971f0c48) (2011-07-01)
X-Provags-ID: V02:K0:9VqyiQpkaKhjUDgADf7EkXpms0/Zi29DsJ/ab08AzEl
 Z6ZphbuRO43KVY8Pb2Iqt9Q0c/Ysa/ZnLNv1XrgLgI0dbEifhZ
 xsEttmn20lCMbrVANcNCG2ziElUbICTw2RSJgEMYlJ46Xnm8XN
 jMbpYslsQVB4k0J+RJi/QAs/HJHCZwCtWs6EsLMKsAqpn8vxTC
 pT9NFALDACME2BQvTMQ66EB431/W0UQoPTwOEo91KWYcNvddMf
 efI0FDsmXKV3K4f01z7eiYigzvcBPXNsrQ/JSew8G9ycaTRQro
 DlLIYBcRhlfMCuXTNazgpHnZthS3ANhkHrf6P/0O5B37r68s3g
 r6YLidaYtidt2EAhp/LW1kbgpFW/nusEspKqsokLe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.12.2012, Heinz Diehl wrote: 

[....]

Ok, the last one for today. After extensive testing with heavy load
and I/O while watching HD videos, I can almost safely conclude with 
the following:

1.) The hang does *never* occur with 3.6.9 vanilla 

2.) The hang does *always* occur with 3.7-rc8+ / latest git

3.) The hang doesn't occur with 3.7/latest git when 

 Driver "Intel"
 Options "NoAccel" "True" 

in Xorg.xonf is set (with all the drawbacks this introduces). Maybe
this rings a bell for someone..

In all cases, the machine is booted with "i915.i915_enable_rc6=0".

Please contact me if you think I can help to debug this further.

Thanks,
Heinz.






