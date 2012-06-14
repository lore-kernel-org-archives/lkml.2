Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2FNKsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:48:25 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62326 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2FNKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:48:24 -0400
Date: Thu, 14 Jun 2012 12:48:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: kernel/cpu/mtrr/cleanup.c simple_strtoul cleanup
Message-ID: <20120614104819.GA8683@gmail.com>
References: <1339612907.13326.5.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339612907.13326.5.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shuah Khan <shuahkhan@gmail.com> wrote:

> Change parse_mtrr_spare_reg() to call kstrtoul() instead of calling obsoleted
> simple_strtoul().
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>  arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

There's about 22 simple_strto*() uses remaining in arch/x86/ - 
please send a single patch that addresses them in one go, 
instead of these peacemail patches...

Thanks,

	Ingo
