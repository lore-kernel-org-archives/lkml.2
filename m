Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab2JKQhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:37:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:58864
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298Ab2JKQhW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:37:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1155h)
Date: Thu, 11 Oct 2012 11:37:18 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the
 powerpc-merge tree
To: Timur Tabi <B04825@freescale.com>
CC: Alexander Graf <agraf@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au>
	<6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net>
	<20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au>
	<6AE080B68D46FC4BA2D2769E68D765B7080FA9F8@039-SN2MPN1-023.039d.mgd.msft.net>
	<6201AAAD-F575-4D2C-9A97-3EB41DA3491C@suse.de>
	<5076EBFE.5060208@freescale.com>
In-Reply-To: <5076EBFE.5060208@freescale.com> (from B04825@freescale.com on
	Thu Oct 11 10:55:42 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1349973438.6903.4@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 10:55:42 AM, Timur Tabi wrote:
> Alexander Graf wrote:
> 
> 
> > This is about kvm_host.h, which is the part that is exported to user
> > space. It usually contains constants and structs that are required  
> for
> > the API.
> 
> Which API?  I'm not familiar with KVM internals.
> 
> My concern is that when I think of a user-space header file, I think  
> of a
> user-space application that calls ioctls.  I know that KVM guest  
> kernels
> run as user-space processes, but that does not seem like a reason to
> combine all of the header files that the KVM guest kernel needs with
> "real" user-space header files.

So where should guest headers go?

-Scott
