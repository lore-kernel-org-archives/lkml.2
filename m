Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab1JCIeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:34:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34219 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1JCIeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:34:25 -0400
MIME-Version: 1.0
In-Reply-To: <1317388114.3935.2.camel@phoenix>
References: <1317388114.3935.2.camel@phoenix>
Date: Mon, 3 Oct 2011 10:34:24 +0200
Message-ID: <CACRpkdaDXQRA-vGDFTi=yHkhbBh=NOak4sSMwzdFNyYO1aTU2Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] pinmux: fix pinctrl_register error handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 3:08 PM, Axel Lin <axel.lin@gmail.com> wrote:

> Hi Linus,
> The fix is base on my understanding of the driver-model code,
> and it is untested ( only compile test), thus I add [RFC] on subject line.
> Also CC Greg KH who is the maintainer of drivers/base/*.

You understand it better than me for sure, I have rebased the patch
on the v9 patchset and applied it to my tree.

Thanks!
Linus Walleij
