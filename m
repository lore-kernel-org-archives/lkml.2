Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965868Ab2EPJRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:17:47 -0400
Received: from ozlabs.org ([203.10.76.45]:59266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759599Ab2EPJRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:17:43 -0400
Date: Wed, 16 May 2012 19:15:01 +1000
From: Paul Mackerras <paulus@samba.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alexander Graf <agraf@suse.de>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kvm-ppc tree
Message-ID: <20120516091501.GA30694@bloggs.ozlabs.ibm.com>
References: <20120516172416.781859dbc2febbda67407576@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516172416.781859dbc2febbda67407576@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 05:24:16PM +1000, Stephen Rothwell wrote:
> Hi Alexander,
> 
> After merging the kvm-ppc tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> ERROR: "kvm_hpt_order" [arch/powerpc/kvm/kvm.ko] undefined!
> 
> Caused by commit ec26346431bb ("KVM: PPC: Book3S HV: Make the guest hash
> table size configurable").

Oops, my fault, kvm_hpt_order needs to be exported for when KVM is
a module.  Patch coming.

Paul.
