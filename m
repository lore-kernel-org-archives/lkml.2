Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab1APXlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 18:41:23 -0500
Received: from ozlabs.org ([203.10.76.45]:37323 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1APXlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 18:41:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] param: add null statement to compiled-in module params
Date: Mon, 17 Jan 2011 10:11:15 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
References: <1294230424-4089-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1294230424-4089-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101171011.16182.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jan 2011 10:57:04 pm Linus Walleij wrote:
> Add an unused struct declaration statement requiring a
> terminating semicolon to the compile-in case to provoke an
> error if __MODULE_INFO() is used without the terminating
> semicolon. Previously MODULE_ALIAS("foo") (no semicolon)
> compiled fine if MODULE was not selected.

I really prefer the other way; make everyone use a semicolon.

Let's look how many we're talking about... hmm, I'm having
trouble finding any!

Could you patch this the other way, to make MODULE_ALIAS w/o a
semicolon always an error?

Thanks,
Rusty.
