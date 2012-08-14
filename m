Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2HNXto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 19:49:44 -0400
Received: from mail.kernelconcepts.de ([212.60.202.196]:58895 "EHLO
	mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139Ab2HNXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 19:49:42 -0400
X-Greylist: delayed 2015 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2012 19:49:42 EDT
Message-ID: <502ADC2E.5070003@kernelconcepts.de>
Date: Wed, 15 Aug 2012 01:15:58 +0200
From: Simon Budig <simon.budig@kernelconcepts.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: Tree for Aug 14 (drivers/input/touchscreen/edt-ft5x06.c)
References: <20120814135506.b6b86e3c8cb9da1eefb7bbd6@canb.auug.org.au> <502A9200.1020606@xenotime.net>
In-Reply-To: <502A9200.1020606@xenotime.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/14/2012 07:59 PM, Randy Dunlap wrote:
> on x86_64, when CONFIG_DEBUG_FS is not enabled:
> 
> drivers/input/touchscreen/edt-ft5x06.c: In function
> 'edt_ft5x06_ts_remove': 
> drivers/input/touchscreen/edt-ft5x06.c:846:14: error: 'struct
> edt_ft5x06_ts_data' has no member named 'raw_buffer'

Yeah, unfortunate oversight on my part.

Guenter Roeck provided a patch for this issue which looks good to me.
(Aug 7th, linux-input mailinglist)

Dmitry: Can you upstream this? Is there any action required on my part?

Thanks,
        Simon
- -- 
       Simon Budig                        kernel concepts GmbH
       simon.budig@kernelconcepts.de      Sieghuetter Hauptweg 48
       +49-271-771091-17                  D-57072 Siegen

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlAq3C4ACgkQO2O/RXesiHAofACgsPG5EcF3fn0me1STCIK5nYwm
4QkAoL+Q30zA0NLNbUSPJIRt6CmR4o91
=y99v
-----END PGP SIGNATURE-----
