Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0EDURQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab0EDURN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:17:13 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org, mjt@tls.msk.ru,
       stable@kernel.org
Subject: Re: [PATCH 0/2] aio: fix the vectored aio routines
References: <1272660540-6567-1-git-send-email-jmoyer@redhat.com>
	<20100504131353.adf8c186.akpm@linux-foundation.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 04 May 2010 16:16:12 -0400
In-Reply-To: <20100504131353.adf8c186.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 4 May 2010 13:13:53 -0700")
Message-ID: <x49wrvj1kz7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 30 Apr 2010 16:48:58 -0400
> Jeff Moyer <jmoyer@redhat.com> wrote:
>
>> Hi,
>> 
>> It was reported[1] that 32 bit readv and writev AIO operations were
>> not functioning properly.  It turns out that the code to convert the
>> 32bit io vectors to 64 bits was never written.  The results of that
>> can be pretty bad, but in my testing, it mostly ended up in generating
>> EFAULT as we walked off the list of I/O vectors provided.
>> 
>> This patch set fixes the problem in my environment.  Comments, as always,
>> are greatly appreciated.
>> 
>> Cheers,
>> Jeff
>> 
>> [1] http://lkml.org/lkml/2010/3/8/309
>> 
>> [PATCH 1/2] compat: factor out compat_rw_copy_check_uvector from compat_do_readv_writev
>> [PATCH 2/2] aio: fix the compat vectored operations
>
> The patches are large(ish) and we're at -rc6.  I'm inclined to merge
> these into 2.6.35-rc1 with a -stable tag so they get backported into 2.6.34.1
> after a bit of mainline testing, OK?

That's fine with me.

Cheers,
Jeff
