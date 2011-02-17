Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1BQRZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:25:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223Ab1BQRZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:25:51 -0500
MIME-Version: 1.0
In-Reply-To: <1297123347-2170-1-git-send-email-dtor@vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 09:24:58 -0800
Message-ID: <AANLkTim_BL_Cw=X0iuatgw1F4n50CyXv0uqx9n=5=Bq+@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 4:02 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
>
> Moreover, as DaveM said, we can't reliably put structures into
> independent objects, put them into a special section, and then expect
> array access over them (via the section boundaries) after linking the
> objects together to just "work" due to variable alignment choices in
> different situations.

Why not?

That's what we normally do. Just align the "__modver", and you should
be all good. What's the problem?

                     Linus
