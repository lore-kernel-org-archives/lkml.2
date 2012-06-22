Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248Ab2FVFqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 01:46:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57531 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761204Ab2FVFqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 01:46:44 -0400
Date: Fri, 22 Jun 2012 06:46:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH -next] avr:  Fix sanitize tsk_is_polling fallout
Message-ID: <20120622054641.GA14083@ZenIV.linux.org.uk>
References: <1339925024-23323-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339925024-23323-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2012 at 11:23:44AM +0200, Geert Uytterhoeven wrote:
> commit 6222033ea7bfe166f06aff5462dd88fba70e74f6 ("sanitize tsk_is_polling()")
> removed the definition of TIF_POLLING_NRFLAG, but forgot to remove the
> continuation line, causing:
> 
> arch/avr32/include/asm/thread_info.h:80: error: expected identifier or '(' before numeric constant
> include/linux/thread_info.h:128: error: implicit declaration of function 'set_ti_thread_flag'
> make[2]: *** [arch/avr32/kernel/asm-offsets.s] Error 1

Thanks for catching that one...  Folded and pushed.
