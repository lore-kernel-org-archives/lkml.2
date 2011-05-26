Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1EZGme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:42:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1EZGmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:42:32 -0400
Message-ID: <4DDDF64F.30207@redhat.com>
Date: Thu, 26 May 2011 09:42:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Marcelo Tosatti <mtosatti@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (kvm
 tree related)
References: <20110525132809.6d85b3c2.sfr@canb.auug.org.au> <20110525080223.GC2498@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20110525080223.GC2498@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2011 11:02 AM, Heiko Carstens wrote:
> On Wed, May 25, 2011 at 01:28:09PM +1000, Stephen Rothwell wrote:
> >  Hi all,
> >
> >  After merging the final tree, today's linux-next build (powerpc
> >  ppc44x_defconfig) failed like this:
> >
> >  cc1: warnings being treated as errors
> >  arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memory_region':
> >  arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer from integer of different size
> >  arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer from integer of different size
> >
> >  Caused by commit 95de6ce677d6 ("KVM: add missing void __user * cast to
> >  access_ok() call").
> >
> >  I have reverted that commit for today.
>
> My fault.. sigh.
>
> Avi could you apply the patch below as well (or merge with the previous one)?
>

Thanks for the quick fix, applied.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

