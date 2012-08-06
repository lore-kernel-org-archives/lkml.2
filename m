Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2HFG6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 02:58:19 -0400
Received: from ozlabs.org ([203.10.76.45]:41747 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab2HFG6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 02:58:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Barbaros =?utf-8?Q?Tokao=C4=9Flu?= <barbarost@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: Fix compile error for ref_module when CONFIG_MODULES is not set
In-Reply-To: <CAL7r9b39L1HuKis+PxOh9tAJ0iEwsP2c+k+=6w00JWCa=FwW5w@mail.gmail.com>
References: <CAL7r9b39L1HuKis+PxOh9tAJ0iEwsP2c+k+=6w00JWCa=FwW5w@mail.gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 06 Aug 2012 10:00:52 +0930
Message-ID: <87vcgwzwsj.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012 20:57:07 +0300, Barbaros Tokaoğlu <barbarost@gmail.com> wrote:
> ref_module function is not defined when CONFIG_MODULES is not set thus
> it causes compile error when a module which is set to be built-in uses it.
> This patch defines a dummy ref_module function when CONFIG_MODULES
> is not set.
> 
> Signed-off-by: Barbaros Tokaoğlu <barbarost@gmail.com>

Hi Barbaros,

        It's usually a good idea to paste the error message into the
commit message for compile fixes: it helps people googling the problem.

In this case, it's particularly important, because I can't find any
users of ref_module() outside module.c itself: it's only exported for
ksplice to use.

Cheers,
Rusty.
