Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab2BNAjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:39:20 -0500
Received: from ozlabs.org ([203.10.76.45]:42151 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686Ab2BNAjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:39:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] [resend] fix broken isapnp handling in file2alias (for 3.3-rc)
In-Reply-To: <201202131552.59524.linux@rainbow-software.org>
References: <201202131552.59524.linux@rainbow-software.org>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 14 Feb 2012 10:50:18 +1030
Message-ID: <87d39iclkt.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 15:52:59 +0100, Ondrej Zary <linux@rainbow-software.org> wrote:
> Handling of isapnp module aliases was broken by commit
> 626596e295d477c0fefa08cd5daa7dd011b1bb2c by changing "isapnp" string to "isa".
> The code was then modified by commit
> e49ce14150c64b29a8dd211df785576fa19a9858 but this bug remained.
> 
> Change the string back to "isapnp".
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Thanks, I've already queued this, it's in linux-next and I'll be sending
to Linus today.

Cheers,
Rusty.
