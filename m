Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab0K2SUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 13:20:17 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54388 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0K2SUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 13:20:16 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: shaohui.zheng@intel.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [8/8, v5] NUMA Hotplug Emulator: documentation
In-Reply-To: Your message of "Mon, 29 Nov 2010 17:17:58 +0800."
             <20101129091936.322099405@intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20101129091750.950277284@intel.com>
            <20101129091936.322099405@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1291054756_5346P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Nov 2010 13:19:16 -0500
Message-ID: <14037.1291054756@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4CF3EEA6.0075,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1291054756_5346P
Content-Type: text/plain; charset=us-ascii

On Mon, 29 Nov 2010 17:17:58 +0800, shaohui.zheng@intel.com said:
> From: Shaohui Zheng <shaohui.zheng@intel.com>
> 
> add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
> to explain the usage for the hotplug emulator.

Can you renumber this to 1/8 if you resubmit it?  It helps code review if you
already know what it's *intended* to do beforehand.  It also helps drinking
from the lkml firehose if you can read 0/N and 1/N and know if it's something
you want to review, otherwise you read 0/N, have to go find N/N, read that,
then go back and delete 1/N through N-1/N.

(Sometimes, the 0/N cover isn't enough - reading the documentation actually
fills in enough blanks to make you go "Wow, this *is* applicable to something
I'm working on...")

--==_Exmh_1291054756_5346P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM8+6kcC3lWbTT17ARAj6WAJ4tCPKF3cl+pr8CIqbYqnnZcZJdXQCgud75
3VeADOnX9iF0goAKVzEvMac=
=JOyu
-----END PGP SIGNATURE-----

--==_Exmh_1291054756_5346P--

