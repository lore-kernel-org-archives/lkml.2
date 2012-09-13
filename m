Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab2IMOJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:09:22 -0400
Received: from mga06.intel.com ([134.134.136.21]:14121 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752593Ab2IMOJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1209131512161.9845@tundra.namei.org>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
	<20120816013434.872.8115.stgit@warthog.procyon.org.uk>
	<CALLzPKbsp0EnZMTmfWtjfctsZn+YAurA_5W=hqzy1kHuxiCGng@mail.gmail.com>
	<alpine.LRH.2.02.1209131512161.9845@tundra.namei.org>
Date: Thu, 13 Sep 2012 17:09:09 +0300
Message-ID: <CALLzPKZGJb+-RKbFHo+X_GXoci5QrSP4=kGYg21sSkqt+23J1w@mail.gmail.com>
Subject: Re: [PATCH 02/25] MPILIB: Provide count_leading/trailing_zeros()
 based on arch functions
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, rusty@rustcorp.com.au,
        zohar@linux.vnet.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O

On Thu, Sep 13, 2012 at 8:14 AM, James Morris <jmorris@namei.org> wrote:
> On Mon, 10 Sep 2012, Kasatkin, Dmitry wrote:
>
>> > Signed-off-by: David Howells <dhowells@redhat.com>
>> > Cc: David S. Miller <davem@davemloft.net>
>> > Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>> > Cc: Arnd Bergmann <arnd@arndb.com>
>>
>> Hi James,
>>
>> Can you please apply this?
>
> Could you send me this and any other outstanding changes as patches
> against my -next branch, tested and signed-off ?
>
> Or, perhaps Mimi could do that as maintainer of the integrity subsystem.
>
>

Ok. let's do it with other collection of patches...

> - James
> --
> James Morris
> <jmorris@namei.org>
