Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab1L0X5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:57:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:47588 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1L0X5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:57:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
In-Reply-To: Your message of "Fri, 23 Dec 2011 16:47:42 +0400."
             <20111223124920.661126615@openvz.org>
From: Valdis.Kletnieks@vt.edu
References: <20111223124741.711871189@openvz.org>
            <20111223124920.661126615@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1325030069_3579P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Dec 2011 18:54:29 -0500
Message-ID: <249444.1325030069@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020202.4EFA5ABB.00D1,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1325030069_3579P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Dec 2011 16:47:42 +0400, Cyrill Gorcunov said:
> The routine XORs the given pointer with a random value
> producing an ID (32 or 64 bit, depending on the arch).

> Index: linux-2.6.git/mm/Kconfig

> +config GENERIC_OBJECT_ID
> +	bool "Enable generic object ID infrastructure"
> +	depends on CHECKPOINT_RESTORE
> +	default n
> +	help
> +	  Turn on the functionality that can generate IDs for kernel

"Turn on functionality"

> +	  objects, which are exported to userspace via /proc filesystem.

Lose the ,

> +
> +	  It is useful if you need to examinate kernel objects and test

examine

> +	  if they are shared between several tasks. These IDs should never
> +	  be used for anything but the "sameness" test. Besides, the IDs are

s/Besides, the/The/

> +	  dynamic and valid only while object is alive, once it get freed or

s/alive, once/alive. Once/

> +	  kernel is rebooted -- the IDs will be changed.

s/ --/,/

Also, see Andrew's comments regarding a generic foo_fields_equal() in-kernel.

--==_Exmh_1325030069_3579P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFO+lq1cC3lWbTT17ARAlrdAJ45Sammm+wou6E8xWYrQRNSZuNiOACfeat/
0JGpyyA5vEyF3IQuPkdoIc8=
=AwX/
-----END PGP SIGNATURE-----

--==_Exmh_1325030069_3579P--

