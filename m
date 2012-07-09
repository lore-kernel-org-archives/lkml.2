Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2GIWkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 18:40:07 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:11937 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2GIWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 18:40:04 -0400
X-Authority-Analysis: v=2.0 cv=QrvcLCOd c=1 sm=0 a=1z32XUYsXEkFDc9mdGZDYQ==:17 a=No9QSAnC_oUA:10 a=8iEie87WbnsA:10 a=UodPDTrrUR8A:10 a=S1A5HrydsesA:10 a=8nJEP1OIZ-IA:10 a=fxJcL_dCAAAA:8 a=20KFwNOVAAAA:8 a=xe8BsctaAAAA:8 a=EChO81DBQ0IT6AJ_wCYA:9 a=wPNLvfGTeEIA:10 a=jEp0ucaQiEUA:10 a=1z32XUYsXEkFDc9mdGZDYQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 184.91.123.202
Message-ID: <4FFB5DC3.30803@ubuntu.com>
Date: Mon, 09 Jul 2012 18:40:03 -0400
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: vgoyal@redhat.com
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com,
        kzak@redhat.com, maxim.patlasov@gmail.com
Subject: Re: [patch 0/2] [V4] block: Support online resize of disk partitions
References: <20120709213418.799759100@redhat.com>
In-Reply-To: <20120709213418.799759100@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/09/2012 05:34 PM, vgoyal@redhat.com wrote:
> Phillip, do let me know if I should put your signed-off-by also in the
> patch.

Sure, kernel side looks good.  My original util-linux patches also added a -u update mode to kpartx, which I think is the more useful interface than the lower level resizepart command, but I suppose I can rebase it to apply on top of this patch.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJP+13DAAoJEJrBOlT6nu75cQIIAJvm6ZFxpNNvgkXq0I6blvIj
Q3s5YbzJYecouHPZdy06UXIdfucHKO7WAaMvpmPnDk+JgtltNljVpA50d21NN2lY
k2j2oU9mFHGEKLDnnYobnr6cO2UShaZkrcMtC29S4LaAdgAgPNyD8aTTWS9w0frv
+p2ko+HKvp3neRpOBwfnYXq/rTBLUmOn0k7XsG8QjnNb3aMnMyYp/crV9Kzeb4YX
uCbnIkzN++oDhmnqsLDGt82/VGXZdnA1umISbV9vZw+Q7FfeaiJVMneFxKe5w/FZ
wiCixoCtGhbqtz1hSsUR+rs2ZaDozL0iygSB15Z71aLPim0TLumtRTpfpu+JR3w=
=Vtl+
-----END PGP SIGNATURE-----
