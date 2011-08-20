Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab1HTRjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 13:39:53 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57030 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab1HTRjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 13:39:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/4] nohz: Split extended quiescent state handling from nohz switch
Date: Sat, 20 Aug 2011 13:39:43 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39; KDE/4.6.3; x86_64; ; )
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com> <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2604344.hWDOoI9XhV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201108201339.50046.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2604344.hWDOoI9XhV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart2604344.hWDOoI9XhV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOT/FlAAoJEEFjO5/oN/WBKN4QAJMMd4xcKJU95NAO5/l2wzzM
uqMAF6N2BwxiUJziV+YSNxcQJMpt3SDUFIY+4rNswCMnFilRy7fk7o3JMXjRYNFI
HQX2O/SnluacQhNpoBv3RmQGKGwl03aSYhpYlOg2+BdWXsW3aE0DQ9B/CD0vNPp5
XJaGBqrDKtHcBMNzE2V6fHgjYS6WgqHFM7TgcfN4tscqiAnBYSkGPKsktv1hX9jx
X1KB6ilk5sedkoTPk2q726WSseqZkbjYnBg8876pbLeXuWxU70scA25NMC/nJNN0
/ytTjeT+7dP/dB1WNzvY9zRwRWzEm+5q45wkObnNxYGR/punk9PHo9UFB2oXZQKj
ElOAQplgc7wb4kUKe8//z4GLrHVOawlAQ6yOTY8O34I2DLvPmor6OaDn/JxHrlvS
d8OapghWssvLAF2ix2pI5F9ISjOWDDoOgQfrSXwfFWSOdqiaC0Tfs/B5zBybvJ3Q
EcV8Z0OZpEKnuZ4Q4IhtzD8gB0QV0SADMLtdUWt3XSyFXrGx3PxJ6IBxwrLbHtSA
e5EyVuqcnhHMmunMJc22QPz+eyED83PnaF2i5Q1TRr0HcEu5O+kSCZs6IWtXdkYc
zTKHzl6XPsygxgeCXWfO9fGAT5tjgO07hpHvKwcPdabEDodHqHoAekDh+IMo0fKD
4OHL0jAfjVJJX5KqGQQ6
=Wmb5
-----END PGP SIGNATURE-----

--nextPart2604344.hWDOoI9XhV--
