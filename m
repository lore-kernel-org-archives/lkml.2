Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817Ab0I0QcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:32:14 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42176 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759795Ab0I0QcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uuumlgXD8LbNKX9A/3VAM4aAsBIsakJ5acm1jGzLuzA7mrhj3vqozBY3noDL/Dnni7
         wuovbxbgCQ/MSn3mAzwMEivnZv2DehzO2Lwqg8irZjvWc6CnI3yObNotaLSuZkO3zOKM
         1UacfSmmuZISuUyaLbUf18b5lxpacECViBTHc=
Date: Mon, 27 Sep 2010 12:32:08 -0400
From: tmhikaru@gmail.com
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100927163208.GA4892@roll>
References: <20100927003608.GA20395@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20100927003608.GA20395@kroah.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

	I'm not exactly sure what's going on here and I'd like some help
figuring out what is. For some inexplicable reason, ever since I started
using the 2.6.35.x series with the 2.6.35.3 release, my loadaverages tend to
bounce anywhere from as low to .2 to 1.5 - constantly, while the machine
seems idle. Consistently, there are no programs in D state in ps aux output,
no cpu hogging programs running in top, nothing I can see that should
explain the bizzarely high load average. *Something* is wrong beyond the
mere loadaverage numbers going crazy however, since timed runs of kernel
compiles done with my distro's kernel and 2.6.35.5 show that while there is
no *apparent* use of cpu or disk showing in vmstat while the machine is
idle, the compiles on the newer kernel are taking approximately twice as
long as before. Now, while I could try to figure out what patch started the
problem, I think it would be a better idea for me to make sure I'm looking
for the actual problem in the right place. Therefore, I know that cpu use,
disk I/O, and the kernel can drive the load average up. Of these things, cpu
use and disk I/O are trackable in top/ps output (eg, a process in D state is
waiting on the disk to do something and can't sleep.) but I don't know if
there's any easy way to determine if the kernel itself is doing something
that's driving up the load average. It's perplexing me that I can see the
loadaverage constantly bouncing about but can't seem to find any reason why
it is doing so.

	If you have any tips or recommendations on what I should use to
investigate this further, please let me know. Once I have ensured to my own
satisfaction that I'm not doing something bizzare that's screwing up my
machine, I'll make a detailed bug report and start on figuring out how to
use git bisect.

	Tim McGrath

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKDHCJEncCrqzVruAQLy5wgAmttVucMOOOd0+rsy/DZhORfgwyTN9ru7
b0XXddjJz1ebziEgmTt19V6a0esAdX3zOFESqXygiMu+ceIlayzgEbohq7EKTKKU
GsJ/30W5zN+N/7taRPbg1bii4PqUYu2hNOqWp6YN4IAUj82VRHMP6IQmYnuk6i0V
5G6AebYowtR27UjVr9bSTMLjaOi3l8ud1Zzdi9PVf6zjnHGd/X4jY7lvg11SVP9J
HN0kvpqXLuJfdXrsX0B0i3DRJiCkWwID3sK0iAmDu1tdPoaaResVtwxgT12uovjk
CIxKZGU0/bQzlukgc/ix6iEQyXtdvzkzPYcbwAkNVQucERhQmt5K6A==
=+8VD
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
