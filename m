Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0IPIUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 04:20:11 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51348 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0IPIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 04:20:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: linux-next: manual merge of the bkl-llseek tree with the rr tree
Date: Thu, 16 Sep 2010 10:20:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-next-20100910+; KDE/4.5.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
References: <20100915132646.4aef58f8.sfr@canb.auug.org.au> <20100916065438.GE2429@amit-laptop.redhat.com>
In-Reply-To: <20100916065438.GE2429@amit-laptop.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161020.01392.arnd@arndb.de>
X-Provags-ID: V02:K0:kq1WO9gpSdnKYsKyj6zhH7fppy0UsEEK1wMnhf1nfNt
 LT/eF4OlNYa0+gEnC/PWS9Rja9AnvzKyMUON9Z5S+eFCjAHrxh
 c+jj5Qc2DsfXdtsjWHJ/cZLJbagJ+EmT/EShD5uPDKsYQ2QDc/
 7O0TTfEmGYXyEH3amAHYzMR99r8yGtNmxiRZvo10dK5BKvmy+z
 iPBaLgu3EY94cqJHDaAcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 September 2010 08:54:39 Amit Shah wrote:
> Arnd, the device is supposed to be non-seekable so I'll add a
> nonseekable_open() to the open() call.
> 
> So I guess the llseek operation should ne no_llseek instead of
> noop_llseek.  Will you change that in your patchset?  Should I do that
> in the patch I'll queue up?

Yes, I think it's best if you just do both changes in your patch, I'll
drop this file from my series then.

Any driver that we can make use no_llseek instead of noop_llseek
is a step forward.

	Arnd
