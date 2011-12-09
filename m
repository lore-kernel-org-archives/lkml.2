Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab1LIOUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:20:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:10137 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab1LIOUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:20:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="84705901"
Message-ID: <4EE2191E.8070107@linux.intel.com>
Date: Fri, 09 Dec 2011 06:20:14 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
References: <alpine.LRH.2.00.1112091505010.20839@tundra.namei.org> <28442.1323269262@redhat.com> <2409.1323422253@redhat.com>
In-Reply-To: <2409.1323422253@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/9/2011 1:17 AM, David Howells wrote:
> James Morris <jmorris@namei.org> wrote:
> 
>>> Could you pull my module signing code into the security tree?
>>> The patches can be viewed here:
>> 
>> I'm getting this build error:
>> 
>> make[1]: *** No rule to make target `kernel.pub', needed by 
>> `kernel/modsign-pubkey.o'.  Stop.
> 
> If you turn module signing on, you have to supply keys for it to
> sign things with and to later verify the signature...
> 
> I wonder what the best way to deal with that is...  I guess make
> allyesconfig and make allmodconfig are going to break otherwise.

the best way to deal is to have KBUILD generate a key on demand ;-)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJO4hkeAAoJEEHdSxh4DVnEWZoIAIJ8MvXcW6B7MbO5V8J7RjDc
h04/xt6UXdg/IZqOFNvVSxNHgfNR2PeRHpNH6kbi8ftX4rp18U7n1y6+WHoMPEHQ
s7+NZQGzhh6TZeVzzAKIKLASnbDIysf8N6eKt0wRRygg3ipj891kMDCLKrkPY3sj
9NL6xOp7uo6p0C9V70UXmO2tqwvtlKnIcD+DcCalnJN+9/pBbhnm13vGFIbTJYsr
uB38DHG4klJceRX+S3CUjFIub1YzW72TevBsenSLdCLBXOHKI/YXqX5uDZyl9pal
nguULAR4Blmv61xN7XJyIJLUmjjy4K7ppR1zxePGVGIalaDqs60PDKJ6ipHoL6o=
=gfR7
-----END PGP SIGNATURE-----
