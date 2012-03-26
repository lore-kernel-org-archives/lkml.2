Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab2CZOo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:44:29 -0400
Received: from gold.linx.net ([195.66.232.40]:36762 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489Ab2CZOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:44:28 -0400
Message-ID: <4F7080D1.4050400@linx.net>
Date: Mon, 26 Mar 2012 15:44:33 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120326 Thunderbird/11.0
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie> <4F70764F.7030409@linx.net> <20120326143250.GN4014@phenom.ffwll.local>
In-Reply-To: <20120326143250.GN4014@phenom.ffwll.local>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 26/03/12 15:32, Daniel Vetter wrote:
> Also, can you check whether disabling vt-d does work around the
> issue?

Yes, that does appear to stay operational for longer on:
Linux adrastea 3.3.0-06972-ge22057c #1 SMP PREEMPT Mon Mar 26 11:29:21
BST 2012 x86_64 Intel(R) Core(TM) i7-2620M CPU @ 2.70GHz GenuineIntel
GNU/Linux

Obviously I would like to have x2apic and my IOMMU back...

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9wgNEACgkQp5vW4rUFj5rhHwCgpwcw0Ydx53CPBcsF1vdo8h1P
ffYAoJYL7RKv0hgc96ZKtFjP7v2V7iRZ
=J/HD
-----END PGP SIGNATURE-----
