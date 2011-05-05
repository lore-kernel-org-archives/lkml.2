Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1EEJSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:18:15 -0400
Received: from gold.linx.net ([195.66.232.40]:55222 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1EEJSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:18:14 -0400
Message-ID: <4DC26B50.7070604@linx.net>
Date: Thu, 05 May 2011 10:18:08 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110503 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Subject: Re: ums-realtek: Unneeded SubClass & Protocol entries (Fujitsu S760
 laptop)
References: <Pine.LNX.4.44L0.1105041232160.2039-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105041232160.2039-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/04/11 17:35, Alan Stern wrote:
> Does the patch below cause the message to 
> go away?

Tested-By: Tony Vroon <tony@linx.net>

- -ums-realtek 1-1.6:1.0: This device (0bda,0138,3882 S 06 P 50) has
unneeded SubClass and Protocol entries in unusual_devs.h (kernel
2.6.39-rc5-00274-g609cfda)
- -   Please send a copy of this message to <linux-usb@vger.kernel.org>
and <usb-storage@lists.one-eyed-alien.net>

That is with your patch applied to 2.6.39-rc6-00041-g5895198. Many thanks.

Regards,
- -- 
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk3Ca1AACgkQp5vW4rUFj5rZ/gCfY5ovrZAWSrWHjJ/pOepuw+uL
EYQAnA6lxmSoD3xEW2x78QmTebiwulCU
=4MJp
-----END PGP SIGNATURE-----
