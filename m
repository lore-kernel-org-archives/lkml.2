Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1LADXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:23:02 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:62661 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab1LADXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:23:01 -0500
X-Authority-Analysis: v=2.0 cv=Vf11zSV9 c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=y8ZX_BOJfaUA:10 a=5Ixo3P5B3vUA:10 a=ZPSk82zQDygA:10 a=xe8BsctaAAAA:8 a=B0t3fPcpIXhLcaBHhR4A:9 a=UAVRJdkkkM0A:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4ED6F313.30408@cfl.rr.com>
Date: Wed, 30 Nov 2011 22:22:59 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Get and Resize BLKPG operations
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Add two new BLKPG generic partition ioctl operations:
1) Resize an existing partition (even if mounted)
2) Get current partition info (Instead of HDIO_GETGO)

Phillip Susi (2):
  Add partition resize function to BLKPG ioctl
  Add BLKPG_GET_PARTITION operation

 block/ioctl.c         |   66 +++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkpg.h |    2 +
 2 files changed, 66 insertions(+), 2 deletions(-)

- -- 
1.7.5.4

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEUEARECAAYFAk7W8w8ACgkQJ4UciIs+XuLabwCglvmxiq+HhdffUjnGIAgWbSxq
UJYAljbxXJwaVPN1c8ia2B5GWsSmJss=
=vWIR
-----END PGP SIGNATURE-----
