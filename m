Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab1BZHun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 02:50:43 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:41525 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1BZHul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 02:50:41 -0500
Message-ID: <4D68B0AE.2090000@seas.upenn.edu>
Date: Sat, 26 Feb 2011 02:50:06 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: jkosina@suse.cz, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, chatty@enac.fr, trivial@kernel.org,
        peter.hutterer@who-t.net
Subject: Re: [PATCH 1/2] HID: ntrig don't dereference unclaimed hidinput
References: <1298610932-21957-1-git-send-email-rafi@seas.upenn.edu> <20110226073633.GA1753@polaris.bitmath.org>
In-Reply-To: <20110226073633.GA1753@polaris.bitmath.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-02-26_03:2011-02-25,2011-02-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1012030000 definitions=main-1102250246
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/26/11 02:36, Henrik Rydberg wrote:
> Hi Rafi,
> 
> On Fri, Feb 25, 2011 at 12:15:31AM -0500, Rafi Rubin wrote:
>> Moved the claimed input check before dereferencing field->hidinput to
>> fix a reported invalid deference bug.
> 
> How long has this problem been seen? If it is recent, it should
> perhaps be fixed in the hid core instead. If it turns out to be an old
> problem, please add stable to the Cc.

I have no idea.  Peter discovered it with a preproduction unit.  He sent me a
proposed fix which seemed quite sensible.  I have not seen the bug in action nor
records of the traffic.

>> Switched to a goto instead of an extra indent for most of the function.
> 
> If you put these janitory changes into a separate patch, it will be
> much easier to apply the bugfix to stable versions.
> 
> Thanks,
> Henrik

It might be a few days, but I'll split that into two patches when I get a chance.

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJNaLCrAAoJEPILXytRLnK2pQsP/3OgaO2YILN9YYuZZxJ+JVa0
cgiFAZxV7BbznMo0sg05RbsF0r1H3rEAzf2JN1NadndC720E6DhDthjvkSZqkdkv
v2gV+NHLyW9qaCsvgGMf7yy72880sA9fL0dzUde+W6rdgH7jgNiAp8ceiDpNIWQH
yj1rOemNuJbXwaC9EiBb0kswxwrshA4nwaDtWxb1/e61nwRrletkrfOX6EX8uNdW
6ogywsVARb1w5A3xZstF2SKPBz9Su/kSlGMgE/j2LizwVoFEZY7Or6JUwpBnHchr
w7a9eKJ4GjW8phU6YQppkNS61tMO4FuToGEYkcDLKbJaGogWO+QeqNA9bqcSjPA/
0F4Zf5CExQjnjmLK4yl0HUPzBtvmJQ/HjpMw6gPFwkqv0QwHUex8QA0Vw3t2LR24
oliI6r6qnuGjHxJidpAdXnhaZn7rB5TCxmHejoAW9MYHKp52xY9IM4ys9lIRSDH+
CbNN6sNL4/VLZrd5hBSnkZxXvPjUq3OQ/uzRPbrXPj0lz7hCt3YLZB1Me1N862uL
81e4T6AqD79dMh/TcwT93PNFD3Sv2mAhgNYBo3j9lz2HjeQR3EvhLXOfHxFwoDgh
k7QYeyKNzYRrTh96EA3zcBIR6yVk3Mq7ASAI/km35nqoEL/iFBAxELS0yKDuuR5z
rtGDDwfYxJDxwsVV93Hx
=AygA
-----END PGP SIGNATURE-----
