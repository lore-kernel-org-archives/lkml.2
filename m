Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161814Ab2COVC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:02:26 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44490 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032348Ab2COVCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:02:23 -0400
Date: Thu, 15 Mar 2012 22:02:19 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb/ub: deprecate & schedule for removal the "Low
 Performance USB Block" driver
Message-ID: <20120315210219.GC6123@breakpoint.cc>
References: <1331758372-9851-1-git-send-email-sebastian@breakpoint.cc>
 <20120315093331.6472333e@lembas.zaitcev.lan>
 <20120315153747.GA23515@kroah.com>
 <20120315181045.GB5702@breakpoint.cc>
 <20120315185648.GC11142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
In-Reply-To: <20120315185648.GC11142@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On > I'll take patches from you to do this, as the removal patch of ub will
> make libusual not need to be stand-alone.
Okay.

> And you will be the one sending the ub removal patch in 6 months, right?

Linus should release 3.3 this weekend. The removal is scheduled for 3.6 which
means 3 releases so something between 3 * 2 .. 3 * 3 months depending how
long each release will take.

> 
> thanks,
> 
> greg k-h

Sebastian
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBCAAGBQJPYljbAAoJEHuW6BYqjPXRRFcP+PvnF1NsmGczvbL6JhalVD8F
cH8COtO5cU7BvI3C7UzP0plURQ5PC0bbqzzayyvkZZyLK6zvwun2G78Ac/viSWQb
GxMAFaXfkx+PN8+agzG1hjTN4BgA51AvRdF776Nn7qIugTxwli6GOthv2aIfgq6s
1aiX0v6Iugm2apoWvGqUT0oe7JCauH2ZS7cd8XWG+C+UcN2D8Wx7ExeQtdN6cCpB
FD31l90AtnQ06A6QI1v78Up3M0m0owhvm/Z0txlPJqYUemLlxfyGjgmlvXL3ypW9
o11PKaNl7jxJ97UW1FNaltC20RVbKQM4K3VPEfcHf4U1V9Cqme0TTAsyG43G9rpg
ObGcQ5YmDsRC2Tt0myW47x1Hhgk+oIEEMriXXLzmJoRo0sQioh3I0hAF4roljSy5
4FB3msEUg7rsLUedRYXnPR1S+I5slWlkzLQRHk2dJ7u4Nakja2hJSGMzS/ZDWVCl
LkPwhD/RQ02mlB15PogeJ39Q1B5Qy3jW/ICLEaIfXdGikUnEazGa9Cp9ek8G7ULF
obmevTbtRqBapyGzRUc41jVXhEkGfefJuhO4ADG7kDyglgVk5iuu0ENSwqcP7Cd4
O6QgsaKZrIXPjsUq2RupPLdU+UnZnzWee13oB9EfokBxGYg5G++NVHA1IN9Au7p8
mNKos9Cb74Sl13vYCSs=
=uzZf
-----END PGP SIGNATURE-----
