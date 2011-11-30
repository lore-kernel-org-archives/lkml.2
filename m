Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1K3ODS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:03:18 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33820 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522Ab1K3ODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:03:16 -0500
Message-ID: <1322661795.2123.12.camel@Joe-Laptop>
Subject: Re: [PATCH] pinmux: Message logging neatening
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Nov 2011 06:03:15 -0800
In-Reply-To: <CACRpkdY_jYphjdZ34wHxVAY0O4rncqd_8pr_chHdr2k+zgVjBg@mail.gmail.com>
References: <1d60ae08aa337a80604cf605565f74bc34bb3b32.1322596881.git.joe@perches.com>
	 <CACRpkdY_jYphjdZ34wHxVAY0O4rncqd_8pr_chHdr2k+zgVjBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 14:08 +0100, Linus Walleij wrote:
> On Tue, Nov 29, 2011 at 9:05 PM, Joe Perches <joe@perches.com> wrote:
> > Coalesce formats.  Argument aligning.
> > Rename pr_warning to pr_warn.
> > Add a couple missing newlines to format strings.
> I've just re-massaged much of this code in recent patches, can we save this
> cleanup for later?

Of course.

