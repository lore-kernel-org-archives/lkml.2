Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2HNMkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 08:40:43 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55168 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2HNMkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 08:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <1344494323-4992-1-git-send-email-thierry.reding@avionic-design.de>
References: <1344494323-4992-1-git-send-email-thierry.reding@avionic-design.de>
Date: Tue, 14 Aug 2012 14:40:41 +0200
Message-ID: <CACRpkdb=9nN-ArV2KzzzwjQx3KnrdsMWE_iRABg283maueYZgg@mail.gmail.com>
Subject: Re: [PATCH] gpio: Fix debug message in of_get_named_gpio_flags()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 8:38 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> This was probably missed in the conversion done in commit 3d0f7cf
> ("gpio: Adjust of_xlate API to support multiple GPIO chips").
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Applied to my fixes branch, Grant: complain if it looks wrong.

Yours,
Linus Walleij
