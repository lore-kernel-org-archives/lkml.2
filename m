Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964871Ab2KOKUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:20:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50302 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2KOKUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:20:52 -0500
MIME-Version: 1.0
In-Reply-To: <1352601091.23129.7.camel@phoenix>
References: <1352601091.23129.7.camel@phoenix>
Date: Thu, 15 Nov 2012 11:20:51 +0100
Message-ID: <CACRpkdYHx0A0+Uk-Lz548gE-trnabkTGG+uhbeJRJQzTNssAxw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: tegra: Staticize non-exported symbols
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2012 at 3:31 AM, Axel Lin <axel.lin@ingics.com> wrote:

> They are not referenced outside of this file, make them static.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied with Stephen's ACK, thanks!

Yours,
Linus Walleij
