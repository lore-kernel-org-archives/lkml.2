Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab2CVTPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:15:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55977 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2CVTPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:15:06 -0400
Message-ID: <4F6B7A37.3020300@canonical.com>
Date: Thu, 22 Mar 2012 15:15:03 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Regression introduced in v3.2.12 stable
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I figured I'd send a heads up regarding a possible regression in v3.2.12
stable.  The issue prevents systems from booting.

There have been a few bugs[0] reported against the Ubuntu kernel, which
was recently rebased to 3.2.12.  We're in the process of bisecting now
and will post an update..

Thanks,

Joe

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/961482
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPa3o3AAoJEGzvPSfKWxQeiXEQAMFKzJj+urC+JyVXfTOOjV/z
iv7/nMAHFPvKgNpDFpk+SM3pFDgZJ/7JZn5Bjl6nidycJy79uCoYxBehBycohtkn
De3Qvefq4lUvIdVpxbM1GhjxRphru8tnGmUOsC1a9S30aYPhRKcHSIGpZZyaSE7k
XmdbI3XEtu1pNiML4Q7lJku5VbOrAt4mm0vBoNpczdTikaAsuLsNnLPju94el3iR
z0Ra7U5buxM06d4T81xoOqVRmcVU8kVsC9Rebp7W2Cfo8VBkkzdlyRsmCCVFL7j/
3Hi5Ir0DCSY7nvPgnlcmOPvF9J4TwgCDkpAheNFkQQph3jc9q7XrlsG3310LeAW7
7w4dtTt+m7FmkmveRmvkC54av2YdqgabcJDMDPlXQ6GC6tdYU7H3dvvKJsz1NbT0
H5JlURCE0zmnMEUnErVLhMCrNm3AFdQQGpJkut3roapSxJfARatowu5Vu+eFzmhV
DCwZpRUKjdvCd88dn+blSBRTb2BLDGYTSP5/Lp2gehdeStrLs3QVJDq8VDGHQUq5
b5zAM1BAmgtT8eCyJHLGVrjO7dmuMRVBqitn4IGbcAeUbd9bSNxuZ4fnkjrVlW4f
Qy1xzws5qGqSYQt39tIG0uvSYar2U4UBUmJERr1FBAEb5FvnGnA5enB75RFWqwR1
q8dxiWcHxI9jG4/wVFq7
=3Uid
-----END PGP SIGNATURE-----
