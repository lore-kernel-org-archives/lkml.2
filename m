Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1LJSyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 13:54:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:49370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LJSyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 13:54:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100821865"
Message-ID: <4EE3AAF8.4090609@linux.intel.com>
Date: Sat, 10 Dec 2011 10:54:48 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: =?ISO-8859-2?Q?Arkadiusz_Mi=B6kiewicz?= <a.miskiewicz@gmail.com>
CC: David Howells <dhowells@redhat.com>, jmorris@namei.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@intel.com,
        zohar@linux.vnet.ibm.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [GIT PULL] Crypto keys and module signing
References: <28442.1323269262@redhat.com> <CA+MtwOEHYu1z8TLXv7jwCKfgavaGX7EWXmxq2xs6b0jbujy35g@mail.gmail.com>
In-Reply-To: <CA+MtwOEHYu1z8TLXv7jwCKfgavaGX7EWXmxq2xs6b0jbujy35g@mail.gmail.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/10/2011 3:42 AM, Arkadiusz Mi¶kiewicz wrote:
> On Wed, Dec 7, 2011 at 3:47 PM, David Howells <dhowells@redhat.com>
> wrote:
>> 
>> Hi James,
>> 
>> Could you pull my module signing code into the security tree?
>> The patches can be viewed here:
>> 
>> http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=shortlog;h=refs/heads/devel
>
>> 
> If I understand it is not possible to sign modules after they are 
> built and load keys without actually rebuilding kernel?

only if the end user chooses to enforce the signature.

> 
> For distro kernel the public and secret keys have to be available 
> publicly, right? Otherwise people using distro kernels won't be
> able to build own signed modules for use with that distro kernel.

That's a distro choice, but... again:

only if the user chooses to enforce the signature.
Very few people actually build their own modules, and for the people
that don't, they can chose to harden their server by only allowing
signed (eg distro shipped) modules.

For those who prefer to build a few other things and still want
security, they can also rebuild the kernel.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)

iQEcBAEBAgAGBQJO46r4AAoJEEHdSxh4DVnE39cIALufzQHXgIycaRnImtEWSPrq
PN5ac052lb59YGEbSsUF/Er/SOLfdwJQbD2Gz2/0QCPWfpb64pozDDwFh1IhvvEp
q4D/1wAJBXOaEj1FESPxHkbwvdYe701pgLq0ERQu4SSx69wNMFXNMmp06Jbxuujp
ZRhQcuJQsd76mJi8MZ2f9qnzR+3MQ9zFGK2alqDfb0WiELBc+Cz1nj2tCXrB5AFa
7osPZJK2iBcD+2sfryMEuJWxOjWxm/ZiEz2oIV0vRtnozVEAIYaeJ2Xe6n72Zj3W
AuAGbnfE9j7yzBVz+9KOZEd2DW7MF7Xns4Vn1/1y6W0h0RsXTq15LIXApJL760I=
=fCSX
-----END PGP SIGNATURE-----
