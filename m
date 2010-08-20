Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab0HTWpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:45:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:40875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab0HTWpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:45:51 -0400
Message-ID: <4C6F0596.2030504@suse.com>
Date: Fri, 20 Aug 2010 18:45:42 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 04/10] ioctl: Use asm-generic/ioctls.h on frv (enables
 termiox)
References: <20100820211401.651509182@suse.com> <20100820211538.515791797@suse.com> <201008210024.39539.arnd@arndb.de>
In-Reply-To: <201008210024.39539.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/20/2010 06:24 PM, Arnd Bergmann wrote:
> On Friday 20 August 2010 23:14:05 Jeff Mahoney wrote:
>> - FRV defines TIOCTTYGSTRUCT, kept in arch-specific version
> 
> Pointless, this was removed by the other architecture, and the
> same change should be done here, possibly in a separate patch.

Agreed.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkxvBZYACgkQLPWxlyuTD7I6DwCeP4N3tAiD1VB3S215KzyckOO6
0NAAoI2qtv6aKz6yDl4dQdBatOLENEwh
=Cnn1
-----END PGP SIGNATURE-----
