Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1K3NIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:08:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55330 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1K3NIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:08:23 -0500
MIME-Version: 1.0
In-Reply-To: <1d60ae08aa337a80604cf605565f74bc34bb3b32.1322596881.git.joe@perches.com>
References: <1d60ae08aa337a80604cf605565f74bc34bb3b32.1322596881.git.joe@perches.com>
Date: Wed, 30 Nov 2011 14:08:22 +0100
Message-ID: <CACRpkdY_jYphjdZ34wHxVAY0O4rncqd_8pr_chHdr2k+zgVjBg@mail.gmail.com>
Subject: Re: [PATCH] pinmux: Message logging neatening
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 9:05 PM, Joe Perches <joe@perches.com> wrote:

> Coalesce formats.  Argument aligning.
> Rename pr_warning to pr_warn.
> Add a couple missing newlines to format strings.
>
> Signed-off-by: Joe Perches <joe@perches.com>

I've just re-massaged much of this code in recent patches, can we save this
cleanup for later?

Yours,
Linus Walleij
