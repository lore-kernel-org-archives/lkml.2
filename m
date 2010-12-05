Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab0LEOdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 09:33:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab0LEOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 09:33:18 -0500
Date: Sun, 5 Dec 2010 15:33:16 +0100
From: Heinz Diehl <htd@fritha.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: device-mapper development <dm-devel@redhat.com>,
        Jon Nelson <jnelson@jamponi.net>, htejun@gmail.com,
        Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
        htd <htd@fancy-poultry.org>, linux-ext4@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [dm-devel] hunt for 2.6.37 dm-crypt+ext4 corruption?
Message-ID: <20101205143316.GA9559@fritha.org>
References: <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
 <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1B43E57B-8DA5-4B34-A8D4-18A710CC8BA7@mit.edu>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:skDazy7mi5otNBbrAoGMmRs7Lf9vEwHPePCRR3jw8gc
 gw+wB7CqNrMDGFc5Y6+wTNuLI9iiyAoG/QqgZ/RbbnodjbqveM
 lpTUwfViRTE1EhZblx9UDrgb0zAXBg00CdFFQM021k3gJ1+KQd
 ko7gnEbfO2svAwQo32fsp7Ie4uhEvAs20Cp79Pbu2m/NLY0fNA
 gVU5gcFUmT7SoxrlZhg4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2010, Theodore Tso wrote: 

> As another thought, what version of GCC are people using who 
> are having difficulty? Could this perhaps be a compiler-related issue?

htd@liesel:~> gcc -v
Using built-in specs.
Target: x86_64-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
--mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
--enable-languages=c,c++,objc,fortran,obj-c++,java,ada
--enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.3
--enable-ssp --disable-libssp --with-bugurl=http://bugs.opensuse.org/
--with-pkgversion='SUSE Linux' --disable-libgcj --disable-libmudflap
--with-slibdir=/lib64 --with-system-zlib --enable-__cxa_atexit
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch
--enable-version-specific-runtime-libs --program-suffix=-4.3
--enable-linux-futex --without-system-libunwind --with-cpu=generic
--build=x86_64-suse-linux
Thread model: posix
gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) 

