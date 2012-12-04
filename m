Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab2LDJMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:12:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35334 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab2LDJMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:12:21 -0500
Date: Tue, 4 Dec 2012 09:12:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] ARM: ux500: Change IRQ from low-to-high edge
 triggered to high-to-low
Message-ID: <20121204091215.GD2718@gmail.com>
References: <1354289099-17931-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdafvpnyq7YMV=iSjN4+u1hpt3xntAb-daJZifG9VpgnOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdafvpnyq7YMV=iSjN4+u1hpt3xntAb-daJZifG9VpgnOw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2012, Linus Walleij wrote:

> On Fri, Nov 30, 2012 at 4:24 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > When the STMPE IRQ is triggered to be active high level-sensitive, the
> > Nomadik GPIO controller it uses complains, although it still works.
> > Recently we attempted to move triggering to low-to-high in an attempt
> > to prevent the warning; however, this ensured that the IRQ was actually
> > missed completely. Now we have a solution which both works and keeps the
> > GPIO controller happy.
> >
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Is this something I should put into the ux500 tree or will you
> take care of this in a separate pull request?

Can you still get this into the RCs, as it's a bugfix?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
