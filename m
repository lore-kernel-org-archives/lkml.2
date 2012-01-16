Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2APLe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 06:34:57 -0500
Received: from ozlabs.org ([203.10.76.45]:52916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab2APLe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 06:34:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Olof Johansson <olof@lixom.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] modules: fix build error with !CONFIG_MODULE_UNLOAD
In-Reply-To: <1326673943-26105-1-git-send-email-olof@lixom.net>
References: <1326673943-26105-1-git-send-email-olof@lixom.net>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 16 Jan 2012 22:02:12 +1030
Message-ID: <87aa5nhohv.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jan 2012 16:32:23 -0800, Olof Johansson <olof@lixom.net> wrote:
> Looks like the "module_flags_taint" helper was added under an #ifdef
> CONFIG_MODULE_UNLOAD block, move it out of it.
> 
> Fixes:
> 
> kernel/module.c: In function 'show_taint':
> kernel/module.c:1024:2: error: implicit declaration of function 'module_flags_taint'
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Applied.

Thanks,
Rusty.
