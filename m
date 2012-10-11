Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab2JKRZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:25:08 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:14682
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932758Ab2JKRZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:25:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1d1ah1d2ah1082kzzz2dh2a8h668h839hd25he5bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <507700EB.5090307@freescale.com>
Date: Thu, 11 Oct 2012 12:24:59 -0500
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
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au> <6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net> <20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au> <6AE080B68D46FC4BA2D2769E68D765B7080FA9F8@039-SN2MPN1-023.039d.mgd.msft.net> <6201AAAD-F575-4D2C-9A97-3EB41DA3491C@suse.de> <5076EBFE.5060208@freescale.com> <1349973438.6903.4@snotra>
In-Reply-To: <1349973438.6903.4@snotra>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
>> > My concern is that when I think of a user-space header file, I think  
>> > of a
>> > user-space application that calls ioctls.  I know that KVM guest  
>> > kernels
>> > run as user-space processes, but that does not seem like a reason to
>> > combine all of the header files that the KVM guest kernel needs with
>> > "real" user-space header files.

> So where should guest headers go?

I admit that I don't have any answers, especially since this whole thing
is new to me.  Like I said, I don't know much about KVM internals, so I
just don't understand why KVM guests need to have access to these kernel
header files as if they're user header files.  The guests are still Linux
kernels (or other OSes that think they're running as privileged code).

-- 
Timur Tabi
Linux kernel developer at Freescale

