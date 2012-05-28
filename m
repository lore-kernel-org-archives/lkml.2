Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2E1PYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:24:03 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54643 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab2E1PYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120528130851.10cca27f0d48da3ccd9d9f95@canb.auug.org.au>
References: <20120528130851.10cca27f0d48da3ccd9d9f95@canb.auug.org.au>
Date: Mon, 28 May 2012 23:24:00 +0800
Message-ID: <CACRpkda5KGQi2AyorWTwQ-LXF-F+9YqyXffJ2-wiaqOJEvcjDw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the pinctrl tree with Linus' tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 11:08 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> <rant>So, if your tree/branch is merged into other trees, DO NOT REBASE
> IT.</rant>

Yeah gr, stupid me. I think I've fixed it up by basing the new stuff on
Torvalds' HEAD FTM, I dunno how I was thinking :-P

Yours,
Linus Walleij
