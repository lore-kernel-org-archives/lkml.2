Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2DBPsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 11:48:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41801 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2DBPsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 11:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com>
Date: Mon, 2 Apr 2012 17:48:38 +0200
Message-ID: <CACRpkdb_qwQBYTC1kPHXhQQmHEzuw7T64pUB57uvw8OUwsOcuA@mail.gmail.com>
Subject: Re: Linux 3.4-rc1
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 1:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:

>  - HSI (High Speed Synchronous Serial Interface) framework. I'm
> planning on pulling this into 3.4, it's in my queue, but I wanted to
> bring it up one more time in case somebody has issues with it. Ping?

We (ST-Ericsson) are already using this code for products, and
we've found out it works pretty well for us. It would be great to have
this upstream, so please pull it in!

Yours,
Linus Walleij
