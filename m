Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1JQLHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 07:07:15 -0400
Received: from mga06.intel.com ([134.134.136.21]:1888 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752509Ab1JQLHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 07:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
	<92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
	<alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
	<CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
Date: Mon, 17 Oct 2011 14:07:11 +0300
Message-ID: <CALLzPKaOYKdPvGvbzQ4DVF9uGt=bY1-j4uSb0PXD1BvBPuu-ww@mail.gmail.com>
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files (part 1)
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        dhowells@redhat.com, herbert@gondor.hengli.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 12:11 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> From Kernel Docbook
>
>    Similar to <function>EXPORT_SYMBOL()</function> except that the
>    symbols exported by <function>EXPORT_SYMBOL_GPL()</function> can
>    only be seen by modules with a
>    <function>MODULE_LICENSE()</function> that specifies a GPL
>    compatible license.  It implies that the function is considered
>    an internal implementation issue, and not really an interface.
>
> "not really an interface"....
>
> Should it really be EXPORT_SYMBOL_GPL?
>
> - Dmitry
>
> On Sat, Oct 15, 2011 at 3:28 AM, James Morris <jmorris@namei.org> wrote:
>> On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:
>>
>>> +MPI mpi_alloc(unsigned nlimbs)
>>> +{
>>> +     MPI a;
>>> +
>>> +     a = (MPI) kmalloc(sizeof *a, GFP_KERNEL);
>>
>> Generally, typedef structs are frowned upon in the kernel.  I'd prefer to
>> see this (and any others) changed to a normal type.
>>
>> Also, kmalloc return values do not need to be cast, they're void *.
>>
>>> +EXPORT_SYMBOL(mpi_alloc);
>>
>> New interfaces should be EXPORT_SYMBOL_GPL.
>>
>>
>> --
>> James Morris
>> <jmorris@namei.org>
>>
>

Hello James,

Also please let me know about other things so that I could fix them as well...

Thanks!

- Dmitry
