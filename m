Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1CHDo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 22:44:27 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:42530 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1CHDoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 22:44:23 -0500
Message-ID: <4D75A606.8040104@seas.upenn.edu>
Date: Mon, 07 Mar 2011 22:44:06 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: Do not create input devices for feature reports
References: <1298572259-18173-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1103011702240.32580@pobox.suse.cz> <AANLkTikd67q_j_ySam7RZvau8WoESLEmdXkfCWerVrLp@mail.gmail.com> <alpine.LNX.2.00.1103011726300.32580@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1103011726300.32580@pobox.suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-08_02:2011-03-08,2011-03-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1103070181
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

A bit on the late side, I can confirm this reverts the annoying proliferation of
input nodes mapped for ntrig hardware.

The new firmwares seem to really enjoy exposing bugs, more on that later.

Rafi

On 03/01/11 11:26, Jiri Kosina wrote:
> On Tue, 1 Mar 2011, Benjamin Tissoires wrote:
> 
>> Tested-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
>> Acked-by: Benjamin Tissoires <benjmain.tissoires@gmail.com>
> 
> Applied, thanks.
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNdaYCAAoJEPILXytRLnK214MP/RC61mIowTq/2o4oWp8JQvy3
l7zZumg3v/tInK7OS1XciWzMQl+zH09FfzutgAEULO7hGhN1RFiP8qiBHtuMrMVg
80FWXIl24SykGe/MwgQPi9esipTx6ee8W7hmIpFOfyVIZIl/F4afdPe3a9fFhuH+
0H5yn7+tUw5n7wglD57xkeDW4a3RD3ehf++ehZhmmwWoPKhr9119XN9UDAmHRBX4
1DfdtOTtsVA161DJkiMipEO5KoeD6dH1VMiCBhxkn+WLpVPHP6zhV/3KUhIDEFDd
oWMvldltbpe8UHQmh2KwiwrtJib0bLIrrmzS5EZkVm8bT2EFlM6ZsYt5tkp6NDwl
/bD1gBrMd14KGwVjb7XflfprlUHbbgpvjDUF7L5B3I955LWsowFoFqjquoV6+Phj
KOJRbUABvDa6esRpg79aAjD59Uh3adnmFydFFcHBHNc3Kb6ROJ4LVGlR1Zxt+QoT
rEXEYuxPZwxJ0zZ08yO2Si+FaoPVOrZC7S2XNhv64MMpISGBWEIvRWowDPjpgutY
v2aVdGiWskPsjqxjVXyR9MTqOgdXrp2JoZy2U2Jq7AV3vzwQfoJ+BJjgEAwkVmO3
XpKuxJ2s5vYPTlxPga3PqUPT2r7PzfjakTcXM4UQ3f7iQy4RZ4qr4q6+4aI3saVy
kvTrsCQV6SmmbbZuaFLh
=h0h3
-----END PGP SIGNATURE-----
