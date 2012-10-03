Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab2JDBYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:24:17 -0400
Received: from ozlabs.org ([203.10.76.45]:52214 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab2JDBYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:24:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
In-Reply-To: <23688.1349186865@warthog.procyon.org.uk>
References: <874nmd4d2o.fsf@rustcorp.com.au> <87wqzdnwus.fsf@rustcorp.com.au> <87ipay3cof.fsf@rustcorp.com.au> <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk> <27378.1348819793@warthog.procyon.org.uk> <29451.1348903010@warthog.procyon.org.uk> <23688.1349186865@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 04 Oct 2012 08:52:51 +0930
Message-ID: <87ehlf2l9w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Rusty Russell <rusty@rustcorp.com.au> wrote:
>
>> Right.  I think we need to use different names for generated vs supplied
>> files
>
> The problem with supplied files is people who do allyesconfig, allmodconfig
> and randconfig just to test things finding that their builds break.  The
> kernel build magic is not really set up to handle external files like this.  I
> suppose make logic can be used to conditionally include stuff that might not
> exist.
>
>> BTW, you missed a Signed-off-by: on your "MODSIGN: Use the same digest
>> for the autogen key sig as for the module sig" patch.  Please update.
>
> Done.
>
> I've also added a patch to convert the system clock to a struct tm and to
> produce a struct tm within the ASN.1 decode and then compare those rather than
> time_t values as a way to deal with the validity time overflow problem.  We
> may have to be able to handle certificates that we haven't generated that
> stretch beyond 2038 (I wonder if we might find such in the UEFI key database
> for example.

OK, cherry-picked to replace my hack.

It's in linux-next, and I will push in the next two days.

Thanks,
Rusty.
