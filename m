Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0FUGVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 02:21:52 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:55378 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0FUGVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 02:21:50 -0400
Message-ID: <4C1F0348.8000804@seas.upenn.edu>
Date: Mon, 21 Jun 2010 02:14:32 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Micki Balanga <micki@n-trig.com>
CC: Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr, dhprince-devel@yahoo.co.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add support to new N-trig firwmare
References: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com> <alpine.LNX.2.00.1006041115480.12271@pobox.suse.cz> <48A28051AC6D7A48B64F28272458190326E03E@Exchange-IL.n-trig.com> <alpine.LNX.2.00.1006051741361.12271@pobox.suse.cz> <48A28051AC6D7A48B64F28272458190338280A@Exchange-IL.n-trig.com>
In-Reply-To: <48A28051AC6D7A48B64F28272458190338280A@Exchange-IL.n-trig.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/21/10 01:06, Micki Balanga wrote:
> Hi Jiri
> We have some new product so I have to update the patch,
> When I update my git branch I didn't see the changes regarding N-trig
> Product id. If you can insert this patch, if there a problem with the
> patch
> Let me know and hi will update it
> Thank you
> Micki
> 
> 
> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz] 
> Sent: Saturday, June 05, 2010 6:42 PM
> To: Micki Balanga
> Cc: chatty@enac.fr; dhprince-devel@yahoo.co.uk;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org; Rafi Rubin
> Subject: RE: [PATCH] HID: Add support to new N-trig firwmare
> 
> On Fri, 4 Jun 2010, Micki Balanga wrote:
> 
>> Hi Jiri,
>> Attach the patch via file.
>> (Also fix 3 warning: please , no space before tabs)
> 
> Thanks Micki, I have applied the patch.
> 

Micki, looks like there are a couple of accidental whitespace modifications:

- -#define USB_VENDOR_ID_ADS_TECH                 0x06e1
+#define USB_VENDOR_ID_ADS_TECH 0x06e1

- -#define USB_VENDOR_ID_EZKEY            0x0518
+#define USB_VENDOR_ID_EZKEY            0x0518


Also, in the list of product ids, did you mean to skip 2?


Jiri, is there a better way than listing each device individually?


Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkwfA0UACgkQwuRiAT9o60+M9QCfQJcJ7pMo9TOY5vYgfK6Yq16d
nD8AoK+l5sVJKAUEpyYEEANnCFCNm/zr
=IFqR
-----END PGP SIGNATURE-----
