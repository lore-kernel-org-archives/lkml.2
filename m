Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1LMP5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:57:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1LMP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:57:35 -0500
Message-ID: <4EE775E8.50403@canonical.com>
Date: Tue, 13 Dec 2011 16:57:28 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: greg@kroah.com, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Please put e5fd47b xen/pm_idle: Make pm_idle be default_idle
 under Xen in 3.0/3.1 stable tree.
References: <20111213154938.GA4955@phenom.dumpdata.com>
In-Reply-To: <20111213154938.GA4955@phenom.dumpdata.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 13.12.2011 16:49, Konrad Rzeszutek Wilk wrote:
> Hey Greg,
> 
> I was going to post the "e5fd47b xen/pm_idle: Make pm_idle be default_idle
> under Xen" with the CC stable@kernel.org but Linus picked up the patch soo
> fast that I did not get to it.
> 
> So please manually back-port the e5fd47bfab2df0c2184cc0bf4245d8e1bb7724fb
> in the 3.1 (and 3.0) stable tree. It does not need to backported in to
> earlier trees.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Thank you!

Hm, might be not needed in 3.0. As far as I see that has not

commit d91ee5863b71e8c90eaf6035bff3078a85e2e7b5
Author: Len Brown <len.brown@intel.com>
Date:   Fri Apr 1 18:28:35 2011 -0400

    cpuidle: replace xen access to x86 pm_idle and default_idle

in it which broke things and went into 3.1.

- -Stefan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJO53XoAAoJEOhnXe7L7s6jT6AP/RGR7umLQ4YGBC04HJCMJDCl
NcEPvyzVwFs9hY0X3KVXt/Gicc7+IvPa6BL/iy0pq3haDlkSCAT45KQu0yQFTpxC
sBzU4ljImZEsVbxy2UQAO1ddUHV2yyEC1vcuDVi9XX7WHQDjSPiatvr7QWdTQYCi
MvdNCLshOLCH08K0lsPynVPXWOZw3K8UiHqQHLX48XxNTMkUi7V+5yfnCkO+75KV
nmRBOUYHclb9MLSsaFIXdf6Il4G+SQhwV+L9NyHR9Cy7+WTYx61JQ+DrjqeudeSQ
up7op99oJ4+QQ+ygINzxl4KaCZ12xNWXW9VcyYtBoU/ofJRqL156GhLqYbyUJSk3
O1C0zLpIn+kxi0MGA2lPUsuZAMKQUw9y1LOP2gBuDoJff34LYqs9XuDIUy+edaru
aKgCuUT8k+QpwukORX9JnBh2v7MILmlgGmY2PRxXnmV79/sBekZ84lQnp6l9VbEk
BRghejE6YW8jEiUOTq7iCgrMvsHb8qw9d7P5k8NsxIe0H6zO6kLs0cd74TLdDqzL
5MxpP8qhDYvX2mxvG1LOvR9n9o6aXZv/nMPxN+py7aZ3xgArTCVDFSpW0+ojinf6
rAdTOtfnZO0lG0YR1HoQJWMvktp+Zowmf17PCLXB7QgByFrsgd8nQ/3Rz6xr7BYx
3MYM73KG1I43WQYVi5H4
=vDeX
-----END PGP SIGNATURE-----
