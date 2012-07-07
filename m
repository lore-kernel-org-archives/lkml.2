Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab2GGBvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:51:20 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:19848 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2GGBvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:51:18 -0400
X-Authority-Analysis: v=2.0 cv=OtDNOlDt c=1 sm=0 a=1z32XUYsXEkFDc9mdGZDYQ==:17 a=No9QSAnC_oUA:10 a=8iEie87WbnsA:10 a=5_Wl8cCxncoA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=xe8BsctaAAAA:8 a=2H0Dy-4fKQciKIBGCzgA:9 a=wPNLvfGTeEIA:10 a=1z32XUYsXEkFDc9mdGZDYQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 184.91.123.202
Message-ID: <4FF79614.2000706@ubuntu.com>
Date: Fri, 06 Jul 2012 21:51:16 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: axboe@kernel.dk, maxim.patlasov@gmail.com, dm-devel@redhat.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: add partition resize function to blkpg ioctl
References: <1329251991-22468-1-git-send-email-vgoyal@redhat.com> <1329251991-22468-2-git-send-email-vgoyal@redhat.com> <20120220152849.GH10342@redhat.com> <20120302185457.GD26315@redhat.com>
In-Reply-To: <20120302185457.GD26315@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

What's the status of this patch?  Forgotten, or are there still any outstanding concerns?

On 03/02/2012 01:54 PM, Vivek Goyal wrote:
> Hi Jens,
> 
> Do you have concerns about this patch? If no, can you please consider
> merging it.
> 
> Thanks
> Vivek
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP95YUAAoJEJrBOlT6nu75A/kIAIEWs+MlA8Me05jjBGpSFQsn
VigiYTF4UdWjA3bG0CNB41eqpzOKVl/B4vTBAy1YezuUXMamBRp1OD6hatEL/blO
ps/M2S2NNPgFOzDmZBgfWIib6tnbCJvTowLdt4n4NnP0DoQRn+5bXopL/jcm4lwU
XWheiqFFX1xSB5YgP+GMl4zVWZhyrHYcynqK/25EimbEXtjgTyR3Cy4wMfGgMdnI
HkY7D0Kn420n+X6uRLXZW8hV3apATZCz3PGsxg7FI83gFi7Tc9rneOhwgRkAXHxq
FcJ2NABK83dACAYOU0fhVTmxoumxuHNCmp7iRGiavnbNCBJWxLV2x1WhceX23lc=
=1FUQ
-----END PGP SIGNATURE-----
