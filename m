Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab2KDRvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 12:51:10 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43630 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2KDRvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 12:51:08 -0500
MIME-Version: 1.0
In-Reply-To: <1351674213.5359.1.camel@phoenix>
References: <1351674213.5359.1.camel@phoenix>
Date: Sun, 4 Nov 2012 18:51:06 +0100
Message-ID: <CACRpkdZ6ogPvzrFfsGJaeD3sCa9SP8kABZU85qbToHdco+CZWw@mail.gmail.com>
Subject: Re: [PATCH] gpio: em: Fix build errors
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Magnus Damm <damm@opensource.se>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 10:03 AM, Axel Lin <axel.lin@ingics.com> wrote:

> Fix below build errors:

Thanks for fixing my screwups! Patch applied to my devel branch
where the patch causing the problems was.

Yours,
Linus Walleij
