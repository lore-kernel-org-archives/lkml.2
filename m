Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2IUDES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:04:18 -0400
Received: from ozlabs.org ([203.10.76.45]:45776 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856Ab2IUDEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:04:16 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] module: add finit_module syscall to asm-generic
In-Reply-To: <201209202152.38630.arnd@arndb.de>
References: <20120920200702.GA18807@www.outflux.net> <201209202152.38630.arnd@arndb.de>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 21 Sep 2012 11:47:40 +0930
Message-ID: <87mx0knmpn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Thursday 20 September 2012, Kees Cook wrote:
>> 
>> This adds the finit_module syscall to the generic syscall list.
>> 
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>> This depends on the finit_module patchset in Rusty's tree, based on
>> https://lkml.org/lkml/2012/9/7/559
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> Please queue this along with the other patches.

OK, I'm still holding them back from linux-next due to the question of
signatures & the new syscall.  But I expect we'll resign ourselves to an
appended signature, and they'll be fine as-is.

Cheers,
Rusty.
