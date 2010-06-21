Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab0FUGi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 02:38:57 -0400
Received: from mxout12.netvision.net.il ([194.90.6.37]:62082 "EHLO
	mxout12.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0FUGi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 02:38:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: RE: [PATCH] HID: Add support to new N-trig firwmare
Date: Mon, 21 Jun 2010 09:39:49 +0300
Message-id: <48A28051AC6D7A48B64F28272458190338281E@Exchange-IL.n-trig.com>
In-reply-to: <4C1F0348.8000804@seas.upenn.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-topic: [PATCH] HID: Add support to new N-trig firwmare
Thread-index: AcsRCgQGVFDRrHh7RxCgKrUlfi4RwAAAjMiQ
References: <48A28051AC6D7A48B64F28272458190333674B@Exchange-IL.n-trig.com>
 <alpine.LNX.2.00.1006041115480.12271@pobox.suse.cz>
 <48A28051AC6D7A48B64F28272458190326E03E@Exchange-IL.n-trig.com>
 <alpine.LNX.2.00.1006051741361.12271@pobox.suse.cz>
 <48A28051AC6D7A48B64F28272458190338280A@Exchange-IL.n-trig.com>
 <4C1F0348.8000804@seas.upenn.edu>
From: Micki Balanga <micki@n-trig.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr, dhprince-devel@yahoo.co.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi rafi
Thank for the remarks
Before submitting the patch I used checkpatch.pl script
And checked whitespace in the code I inserted. 
Yes I aware there is no product id 0x002. (it's ok)
Micki


-----Original Message-----
From: Rafi Rubin [mailto:rafi@seas.upenn.edu] 
Sent: Monday, June 21, 2010 9:15 AM
To: Micki Balanga
Cc: Jiri Kosina; chatty@enac.fr; dhprince-devel@yahoo.co.uk;
linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Add support to new N-trig firwmare

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

Micki, looks like there are a couple of accidental whitespace
modifications:

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
