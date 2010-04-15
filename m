Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0DOXlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:41:50 -0400
Received: from stag.seas.upenn.edu ([158.130.70.79]:56120 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab0DOXls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:41:48 -0400
Message-ID: <4BC7A422.7050601@seas.upenn.edu>
Date: Thu, 15 Apr 2010 19:41:22 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: your mail
References: <20100414125234.23507.42816.stgit@localhost.localdomain> <20100414231604.GA12281@core.coreip.homeip.net>
In-Reply-To: <20100414231604.GA12281@core.coreip.homeip.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

>> +	if (ts->tc.event_sended == false) {
> 
> We set "event_sended" to false immediately before calling
> cy8ctmg110_send_event() so I do not see the point of this flag.

On that note:

$ git grep -n sended
drivers/net/eth16i.c:1295:
		how many packets there is to be sended */
drivers/net/wan/sbni.c:638:
		/* if frame was sended but not ACK'ed - resend it */
drivers/net/wan/sbni.c:659:
		* frame sended then in prepare_to_send next frame
drivers/usb/serial/aircable.c:13:
		* next two bytes must say how much data will be sended.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkvHpB4ACgkQwuRiAT9o609wAgCfbGjTP2lIN6JJyX28VzjPHxTY
ylIAn15FZRPpBEkWaFR8oAFKCCRmNF4d
=u4nx
-----END PGP SIGNATURE-----
