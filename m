Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0H2UIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 16:08:19 -0400
Received: from talbot.seas.upenn.edu ([158.130.67.217]:52179 "EHLO
	talbot.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab0H2UIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 16:08:17 -0400
Message-ID: <4C7ABB41.1020708@seas.upenn.edu>
Date: Sun, 29 Aug 2010 15:55:45 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, chatty@enac.fr, micki@n-trig.com
Subject: Re: [PATCH 3/4] identify firmware version
References: <1282798497-19791-1-git-send-email-rafi@seas.upenn.edu> <1282798497-19791-4-git-send-email-rafi@seas.upenn.edu> <4C77A92F.8020302@euromail.se>
In-Reply-To: <4C77A92F.8020302@euromail.se>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-08-29_06:2010-08-29,2010-08-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1008290141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/27/10 08:01, Henrik Rydberg wrote:
> On 08/26/2010 06:54 AM, Rafi Rubin wrote:
> 
>> This adds firmware version polling to the end of probe and reports the
>> version both in the raw form and proccessed to match the formatting used
>> by ntrig in windows.
>>
>> Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
> 
> 
> The version field of the input_id struct is a 16-bit number that can be used to
> code device-specific version information, and is retrievable via EVIOCGID.
> Perhaps one could code the firmware version in there.
> 
> Henrik

Thanks, I missed that field and will update my approach accordingly.

I suppose in that case, I should also keep the firmware decoding as a userspace
tool.

Micki, would you care to comment on the decoding?  Any misplaced bits, or
additional bits you would like to add mappings for?

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkx6u0EACgkQwuRiAT9o60+8SwCgrjqd+FNJPSEve/tdM7+C0i4/
0xsAmwVg0YDjz3QFukfPyawrZwdoPD3U
=htK1
-----END PGP SIGNATURE-----
