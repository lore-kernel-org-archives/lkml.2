Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758492Ab2JKNFK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:05:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56072 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab2JKNFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:05:07 -0400
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the powerpc-merge tree
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <6AE080B68D46FC4BA2D2769E68D765B7080FA9F8@039-SN2MPN1-023.039d.mgd.msft.net>
Date: Thu, 11 Oct 2012 15:04:58 +0200
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yoder Stuart-B08248 <B08248@freescale.com>,
        David Howells <dhowells@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <6201AAAD-F575-4D2C-9A97-3EB41DA3491C@suse.de>
References: <20121011121841.1b946f996cba995d9a5a2be7@canb.auug.org.au> <6AE080B68D46FC4BA2D2769E68D765B7080FA8F8@039-SN2MPN1-023.039d.mgd.msft.net> <20121011134754.2e2cbb24842fa991e61cf97c@canb.auug.org.au> <6AE080B68D46FC4BA2D2769E68D765B7080FA9F8@039-SN2MPN1-023.039d.mgd.msft.net>
To: Tabi Timur-B04825 <B04825@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.10.2012, at 05:32, Tabi Timur-B04825 wrote:

> On Wed, Oct 10, 2012 at 9:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Commit 549d62d889b4 ("KVM: PPC: use definitions in epapr header
>> for hcalls") from the kvm-ppc tree added an include of asm/epapr_hcall.h
>> to the user visible part of asm/kvm_para.h so asm/epapr_hcall.h became a
>> user visible header file.
> 
> Any real user-space code that tries to call any of the functions in
> epapr_hcall.h will cause an exception.
> 
> Claiming that kernel header files that KVM needs are suddenly
> user-space header files doesn't make much sense to me, but I guess
> it's not my decision.

This is about kvm_host.h, which is the part that is exported to user space. It usually contains constants and structs that are required for the API.


Alex

