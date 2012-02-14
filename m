Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab2BNBYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:24:42 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:19957 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2BNBYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:24:41 -0500
X-Authority-Analysis: v=2.0 cv=Vv2h8pKn c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=wlpneARC_bsA:10 a=2WZXf8VwxVAA:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=YUqSxCbfIJsmvUx5WA0A:9 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4F39B7D7.8050501@ubuntu.com>
Date: Mon, 13 Feb 2012 20:24:39 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        Karel Zak <kzak@redhat.com>, maxim.patlasov@gmail.com
Subject: Re: [PATCH 0/2] block: online resize of disk partitions
References: <1329161438-12602-1-git-send-email-vgoyal@redhat.com> <4F3981FE.7090601@ubuntu.com> <20120213215039.GD3130@redhat.com> <4F398C39.6010901@ubuntu.com> <20120213222454.GF3130@redhat.com>
In-Reply-To: <20120213222454.GF3130@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/13/2012 05:24 PM, Vivek Goyal wrote:
> Ok, so user still specifies just the new size of partition and tool
> passes in both the "start" and new "size" to the ioctl?

Bingo.  Eventually I'm kicking around the idea of having the ioctl allow
changing the start and modifying gparted to be able to use that on a
mounted partition if the fs supports it ( I think btrfs could be made
to without too much difficulty ).  In the mean time, libparted enforces
the start remaining unchanged and parted, gparted, and kpartx automatically
use the existing start position.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPObfXAAoJEJrBOlT6nu75IKwH/jKcbW6L/j/v7hF0rXHql7Tg
/E17+L37YvtwNA3aiZvDmj6FWablT2Dmvi/zcPITJ0FOWtZ+HKQ6+1odqPWRkOl/
4gQrcUyYn/OK/RqyqCM9O6AwpiKZCvAn9LmDc0BCKDptbKshXe+L2GmgOQbiFSdk
2rcbncXI9Sz1pt8nCP8M3gNdYIl6Ln2u0PxwohMoIVGFDhxETdzm8YfX9MfH4Ay6
FU+5chGJUEiXQgjDw5k+vgX85Xc4pC7IRR6vqAZ5I69RxWB4DBteiR0znBNBZG1Z
Mg8cAJTku2n4fZojCAXv35i3gRa3bgwyHv0suaSc2BGKYEeAu41ncAC3q77Arp4=
=Qxgd
-----END PGP SIGNATURE-----
