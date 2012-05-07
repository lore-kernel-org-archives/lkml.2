Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2EGFYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:24:34 -0400
Received: from ozlabs.org ([203.10.76.45]:55857 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab2EGFYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:24:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
In-Reply-To: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 May 2012 12:09:43 +0930
Message-ID: <87ehqwhfyo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Apr 2012 17:11:22 -0700, "Luis R. Rodriguez" <mcgrof@frijolero.org> wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> While the kernel is GPLv2 individual files and modules have
> historically been allowed to be:
> 
>   * Dual BSD/GPL
>   * Dual MIT/GPL
>   * Dual MPL/GPL
> 
> This is done for several reasons but most importantly to be able to
> share between Linux and permissive licensed Operating Systems such
> as the BSDs.

1) It's always better to be explicit.
2) Changing any licencing mark on a file is a PITA, involving acks and
   lawyers.
3) I haven't yet been overwhelmed with the burden of maintaining licence
   strings.

Thanks,
Rusty.
