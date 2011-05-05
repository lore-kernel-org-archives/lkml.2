Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1EEOWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:22:14 -0400
Received: from gold.linx.net ([195.66.232.40]:44893 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754629Ab1EEOWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:22:12 -0400
Message-ID: <4DC2B28B.2090806@linx.net>
Date: Thu, 05 May 2011 15:22:03 +0100
From: Tony Vroon <tony@linx.net>
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110503 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-kernel@vger.kernel.org
Subject: Re: ums-realtek: Unneeded SubClass & Protocol entries (Fujitsu S760
 laptop)
References: <Pine.LNX.4.44L0.1105050955270.1893-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105050955270.1893-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/05/11 14:57, Alan Stern wrote:
> Sorry, I don't quite understand what you mean.  Do those "- -" strings 
> indicate that the message is not present when the patch is applied?

Indeed, I did a diff between the dmesg of the kernel I reported the
problem on, and the dmesg of the newer RC6 with your patch applied.

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

iEYEARECAAYFAk3CsosACgkQp5vW4rUFj5oLHwCfSImae4+NjEvgiqd8J0D7RG2o
HhUAoLH4NpYRXyQS0q5/3cnWqZszZXpS
=KOg0
-----END PGP SIGNATURE-----
