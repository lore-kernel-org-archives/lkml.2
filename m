Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab2JKRcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:32:11 -0400
Received: from [216.32.180.187] ([216.32.180.187]:9702 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932758Ab2JKRcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:32:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zz98dIzz1202h1d1ah1d2ah1082kzzz2dh2a8h668h839hd25he5bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <5077024A.9010209@freescale.com>
Date: Thu, 11 Oct 2012 12:30:50 -0500
From: Timur Tabi <B04825@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Alexander Graf <agraf@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the powerpc-merge
 tree
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au> <6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net> <20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au> <6AE080B68D46FC4BA2D2769E68D765B7080FA9F8@039-SN2MPN1-023.039d.mgd.msft.net> <6201AAAD-F575-4D2C-9A97-3EB41DA3491C@suse.de> <5076EBFE.5060208@freescale.com> <1349973438.6903.4@snotra> <507700EB.5090307@freescale.com> <1349976536.6903.7@snotra>
In-Reply-To: <1349976536.6903.7@snotra>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> For hypercalls and other paravirt.  That's the point -- they're not  
> kernel headers.  They're guest API headers.

Well, IMHO, guest API != user-space.  Maybe we should have a parallel
mechanism to uapi to make the kvm guest header files available.

-- 
Timur Tabi
Linux kernel developer at Freescale

