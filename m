Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1LMAPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:15:10 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:11000 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1LMAPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:15:08 -0500
X-Authority-Analysis: v=2.0 cv=T8wOvo2Q c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=Nme0zjCpHsChgOZgSLwA:9 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EE6990A.9010202@cfl.rr.com>
Date: Mon, 12 Dec 2011 19:15:06 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Joe Perches <joe@perches.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <4EE0C814.2000807@cfl.rr.com> <20111208151650.GB16934@nb.redhat.com> <4EE0D6E6.9000807@cfl.rr.com> <20111208155844.GA9281@redhat.com> <4EE0E085.8000907@cfl.rr.com> <20111208162847.GB9281@redhat.com> <4EE17815.6050806@cfl.rr.com> <20111212145330.GB29180@redhat.com> <4EE63D43.50706@cfl.rr.com> <1323712147.19538.2.camel@joe2Laptop> <20111212180411.GE29180@redhat.com>
In-Reply-To: <20111212180411.GE29180@redhat.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/12/2011 01:04 PM, Vivek Goyal wrote:
>> If it really needs to be 3 letters, and I don't think
>> it does, perhaps BLKPG_RSZ_PARTITION
> 
> Agreed. RES does not occur to me as resize but resources. ADD and DEL
> are very clear. 

Ok, I suppose RESIZE is fine.  Here come both patches, hopefully final.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7mmQoACgkQJ4UciIs+XuIDkwCdEvqpBaxWw5jmgj2PBs/0pStB
IyQAoJHW2U4GeBRy7f/WdKWlN0Vk6pgC
=x4de
-----END PGP SIGNATURE-----
