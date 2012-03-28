Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2C1IzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 04:55:06 -0400
Received: from gold.linx.net ([195.66.232.40]:47552 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab2C1IzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 04:55:04 -0400
Message-ID: <4F72D1ED.8040305@linx.net>
Date: Wed, 28 Mar 2012 09:55:09 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120326 Thunderbird/11.0
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: [git pull] drm main pull for 3.4-rc1
References: <alpine.DEB.2.00.1203211024490.22265@skynet.skynet.ie> <4F70764F.7030409@linx.net> <20120326143250.GN4014@phenom.ffwll.local> <4F7080D1.4050400@linx.net> <20120327193124.GA1971@phenom.ffwll.local> <20120327203913.GA2436@phenom.ffwll.local>
In-Reply-To: <20120327203913.GA2436@phenom.ffwll.local>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 27/03/12 21:39, Daniel Vetter wrote:
> Yet another thing to try: Can you append intel_iommu=igfx_off to
> your kernel cmdline? If you can, try this both on mainline kernels
> and with my additional patches.

To confirm, intel_iommu=igfx_off is stable on both mainline and your
"for-chainsaw" branch with additional SNB patching.

With ppgtt and the iommu fully enabled, your SNB patches remove the
DMAR warnings but do not address the stability problem, in that it
still crashes in the same way.

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9y0e0ACgkQp5vW4rUFj5oTbgCfdY38BXScIWfvEuwdyQr4nwvK
aIMAn3QyLUiEAVxbm2HbufRi8UJXeUa7
=uPoe
-----END PGP SIGNATURE-----
