Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab0D3RZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:25:54 -0400
Received: from gold.linx.net ([195.66.232.40]:50316 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643Ab0D3RZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:25:20 -0400
Message-ID: <4BD999D6.7070808@linx.net>
Date: Thu, 29 Apr 2010 15:38:14 +0100
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
Organization: London Internet Exchange (LINX; AS5459)
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100429 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
References: <20100401133923.GA4104@tiehlicka.suse.cz> <20100419115942.GC5160@tiehlicka.suse.cz> <201004191719.53602.rjw@sisk.pl> <201004250435.42779.rjw@sisk.pl> <20100426150503.GA4005@tiehlicka.suse.cz> <alpine.LFD.2.00.1004261130090.3999@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004261130090.3999@localhost.localdomain>
X-Enigmail-Version: 1.0.1
OpenPGP: id=B5058F9A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 26/04/10 17:22, Len Brown wrote:
> During this period after poweroff and LCD goes out, but before
> lid close, are there any other signs of life?  eg. does caps
> lock button light the caps LED?

The caps lock button does not respond, no.

> How about during this period if you press the power button and
> hold it for 5 seconds, does that cause the HDD parking sound?

Holding down the power button for 5 seconds has no audible or visible
effects, but does indeed properly shut it down. Closing or opening the
lid afterwards does not cause a phantom power-up.
A short push of the power button seems to start the machine up normally
(from a cold boot; just like when the lid is closed/opened after a linux
"shutdown").

> Please send the /proc/acpi/wakeup file before and after
> the regression.

I don't have this file in my /proc filesystem, sorry.

Regards,
- --
Tony Vroon
UNIX systems administrator
London Internet Exchange Ltd, Trinity Court, Trinity Street,
Peterborough, PE1 1DA
Registered in England number 3137929
E-Mail: tony@linx.net
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkvZmdYACgkQp5vW4rUFj5oUxgCdGPnfQsSE9jhjSzzar/kQbw95
Er4AmgLGStZlrvGZltqsU/REs2srO95A
=6VLH
-----END PGP SIGNATURE-----
