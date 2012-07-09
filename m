Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2GIPNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:13:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab2GIPNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:13:39 -0400
Date: Mon, 9 Jul 2012 11:13:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: axboe@kernel.dk, maxim.patlasov@gmail.com, dm-devel@redhat.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: add partition resize function to blkpg ioctl
Message-ID: <20120709151329.GE2538@redhat.com>
References: <1329251991-22468-1-git-send-email-vgoyal@redhat.com>
 <1329251991-22468-2-git-send-email-vgoyal@redhat.com>
 <20120220152849.GH10342@redhat.com>
 <20120302185457.GD26315@redhat.com>
 <4FF79614.2000706@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF79614.2000706@ubuntu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:51:16PM -0400, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> What's the status of this patch?  Forgotten, or are there still any outstanding concerns?

There was one outstanding concern from maxim about missing "bdput(bdevp)".
Will see if I can find some time to brush it up and test patches again. If
somebody can beat me to it, that would be great.

Thanks
Vivek

> 
> On 03/02/2012 01:54 PM, Vivek Goyal wrote:
> > Hi Jens,
> > 
> > Do you have concerns about this patch? If no, can you please consider
> > merging it.
> > 
> > Thanks
> > Vivek
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJP95YUAAoJEJrBOlT6nu75A/kIAIEWs+MlA8Me05jjBGpSFQsn
> VigiYTF4UdWjA3bG0CNB41eqpzOKVl/B4vTBAy1YezuUXMamBRp1OD6hatEL/blO
> ps/M2S2NNPgFOzDmZBgfWIib6tnbCJvTowLdt4n4NnP0DoQRn+5bXopL/jcm4lwU
> XWheiqFFX1xSB5YgP+GMl4zVWZhyrHYcynqK/25EimbEXtjgTyR3Cy4wMfGgMdnI
> HkY7D0Kn420n+X6uRLXZW8hV3apATZCz3PGsxg7FI83gFi7Tc9rneOhwgRkAXHxq
> FcJ2NABK83dACAYOU0fhVTmxoumxuHNCmp7iRGiavnbNCBJWxLV2x1WhceX23lc=
> =1FUQ
> -----END PGP SIGNATURE-----
