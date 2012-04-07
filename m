Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab2DGAgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 20:36:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50554 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2DGAgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 20:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
References: <1333757482-16204-1-git-send-email-mcgrof@frijolero.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Apr 2012 17:36:03 -0700
X-Google-Sender-Auth: piFW34MA_Gnd06Vp68B0X_OX84w
Message-ID: <CA+55aFy_TOEE-8RNmNKVz6xZ7s+f02jCVcDbA=MJY1iih=AJpg@mail.gmail.com>
Subject: Re: [PATCH] module: Clarify GPL-Compatible is OK
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Keith Packard <keithp@keithp.com>, Ralf Baechle <ralf@linux-mips.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 5:11 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> -MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_LICENSE("GPL-Compatible");

I really don't see the point.

This makes things *worse*.

"Dual BSD/GPL" actually tells you something: it tells you that you can
take that code, and use it in a BSD project.

In contrast "GPL-compatible" tells you nothing at all.

So you are actually removing real information, and just making things
harder for everybody.

                Linus
