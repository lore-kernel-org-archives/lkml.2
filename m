Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918Ab2JKBrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:47:20 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9808 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932765Ab2JKBrR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:47:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h8e2h8e3hd25hf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441hbe9i1155h)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        David Howells <dhowells@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the
 powerpc-merge tree
Thread-Topic: linux-next: manual merge of the kvm-ppc tree with the
 powerpc-merge tree
Thread-Index: AQHNp1JVdFCB+A5uXE6KJniBGBQc5g==
Date: Thu, 11 Oct 2012 01:47:13 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net>
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au>
In-Reply-To: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <7EB19B6B60D80D438767EF169E718A3F@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 8:18 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

>  arch/powerpc/include/asm/epapr_hcalls.h      |  511 --------------------------
>  arch/powerpc/include/uapi/asm/Kbuild         |    1 +
>  arch/powerpc/include/uapi/asm/epapr_hcalls.h |  511 ++++++++++++++++++++++++++

What is include/uapi?  epapr_hcalls.h is not a user-space header file.
 I don't remember seeing the original patch which moved it, so I don't
know where this comes from.


-- 
Timur Tabi
Linux kernel developer at Freescale
