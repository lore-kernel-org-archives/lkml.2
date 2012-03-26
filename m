Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab2CZOgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:36:50 -0400
Received: from gold.linx.net ([195.66.232.40]:36609 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932547Ab2CZOgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:36:49 -0400
Message-ID: <4F707F05.7000401@linx.net>
Date: Mon, 26 Mar 2012 15:36:53 +0100
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
> Ok, this is ugly. Do you have any special module options for i915
> set (like i915_enable_rc6)?

None set:
adrastea ~ # cat /proc/cmdline
BOOT_IMAGE=3.3.0-04074-g53 rw root=0

> Also, can you check whether disabling vt-d does work around the
> issue?

Will try. More to follow shortly.

> Last but not least, can you please bisect where this regression got
> introduced so we have an idea why it breaks?

I do not know how to turn these 3.3.0-04074-g5375871 type indicators
into useful git bisect arguments.

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

iEYEARECAAYFAk9wfwUACgkQp5vW4rUFj5pMjQCgoW9nayPhTCkLJZNuuhhpPZTK
Cy4An2GxAzqQN/1xSxF1Fsl/XX73O09d
=2eHw
-----END PGP SIGNATURE-----
