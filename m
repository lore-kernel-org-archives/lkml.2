Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab2EGFYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:24:33 -0400
Received: from ozlabs.org ([203.10.76.45]:57157 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab2EGFYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:24:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        Tso Ted <tytso@mit.edu>, Keith Packard <keithp@keithp.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ralf Baechle <ralf@linux-mips.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arend Van Spriel <arend@broadcom.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] module: Clarify usage of MODULE_LICENSE()
In-Reply-To: <1333903588-32608-1-git-send-email-mcgrof@frijolero.org>
References: <1333903588-32608-1-git-send-email-mcgrof@frijolero.org>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 May 2012 12:30:16 +0930
Message-ID: <87bom0hf0f.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Apr 2012 09:46:28 -0700, "Luis R. Rodriguez" <mcgrof@frijolero.org> wrote:
> From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
> 
> While the kernel is GPLv2 individual the MODULE_LICENSE() has allowed for
> these tag to be used:
> 
>   * Dual BSD/GPL
>   * Dual MIT/GPL
>   * Dual MPL/GPL
> 
> This is done for historical reasons, namely questioning the compatibilty
> between the GPL and some old BSD licenses. Some developers and maintainers
> tend to use assume the macro is also used to help clarify if the module
> source code could be shared with the BSD family, but that is not the
> case.

Incorrect.  When the author clarifies their license it *does* help.  If
a tag and license text were to disagree, it would muddy the waters.

> The MODULE_LICENSE() declares the module's license at run time and even for
> the dual tags the run time license that applies is the GPL.

You're probably correct, but it's very hard to care.

> If sharing share between Linux and permissive licensed Operating Systems such
> as the BSDs is desired developers should review the license on the top of
> each file being considered to be shared.

Of course.  But having both is nice and clear.

Cheers,
Rusty.
