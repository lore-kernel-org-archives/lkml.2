Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab2JKDeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:34:14 -0400
Received: from [65.55.88.15] ([65.55.88.15]:36759 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932783Ab2JKDeL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:34:11 -0400
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
Thread-Index: AQHNp1JVdFCB+A5uXE6KJniBGBQc5pezZvsAgAAMhYA=
Date: Thu, 11 Oct 2012 03:32:46 +0000
Message-ID: <6AE080B68D46FC4BA2D2769E68D765B7080FA9F8@039-SN2MPN1-023.039d.mgd.msft.net>
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au>
	<6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net>
	<20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au>
In-Reply-To: <20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <7C1F74E4EE3F734C88F2B787B7326670@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 9:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Commit 549d62d889b4 ("KVM: PPC: use definitions in epapr header
> for hcalls") from the kvm-ppc tree added an include of asm/epapr_hcall.h
> to the user visible part of asm/kvm_para.h so asm/epapr_hcall.h became a
> user visible header file.

Any real user-space code that tries to call any of the functions in
epapr_hcall.h will cause an exception.

Claiming that kernel header files that KVM needs are suddenly
user-space header files doesn't make much sense to me, but I guess
it's not my decision.

-- 
Timur Tabi
Linux kernel developer at Freescale
