Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1LXVgf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 16:36:35 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:27246 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1LXVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 16:36:31 -0500
X-Authority-Analysis: v=2.0 cv=APbyNIPv c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=acFpV6Ajmw0A:10 a=LNmbJxpDd3oA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=UMrV0lYrjPYvGOAw_lkA:9 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EF645DC.3000202@cfl.rr.com>
Date: Sat, 24 Dec 2011 16:36:28 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: joe@perches.com, kzak@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
References: <4EE6990A.9010202@cfl.rr.com> <1323735382-5972-1-git-send-email-psusi@cfl.rr.com> <20111219202527.GF7175@redhat.com> <4EF13C30.4050307@cfl.rr.com> <20111221204641.GB27789@redhat.com>
In-Reply-To: <20111221204641.GB27789@redhat.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/21/2011 03:46 PM, Vivek Goyal wrote:
> I guess taking disk mutex will help us providing mutual exclusion between
> multiple ioctls or multiple instances of same ioctl. Like, while you are
> extending a partition and checking for overlap, you don't want another call
> making progress on next partition which might overlap with this partition.

Good point; I will put it back and grab it in the correct order.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJO9kXcAAoJEJrBOlT6nu75NcMH/jC8YXfpB6jnCjKtPxP2Hw8G
vRfCULFi3h8WQbRmhR4AvayMJfwTYNkA/QB7TxZ0bYEm8SawesJuVyAKWLe1qutB
AFUEFL6d8+lt8vMcpsK1LWFBACEPd2TIN+oMttbaLTm2J+SOotnCdkKk691cIX8g
PtxEIeAB3NBBxfJ8hJUee3CQb4E0yg7zefdBEctLUC5Y3bKzAHtD5OvboyWf6Ycj
4+VONmaBwHS10hvXnk1CjLJXgjVs5lG+gKniW29SqdnKFbZ3zGl7Ye+QyUyjH9FU
xltg/a+qV5Zx2e3EAi3uTkqaSUgsgo4dCKdCIAmR5+FyhbooJV8xV4d4rdMJvFU=
=taVc
-----END PGP SIGNATURE-----
