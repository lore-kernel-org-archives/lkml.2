Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab2CLRvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:51:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36969 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2CLRvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:51:38 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpio/davinci: fix oops on unbanked gpio irq request
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com
In-Reply-To: <1331469972-2638-2-git-send-email-nsekhar@ti.com>
References: <1331469972-2638-1-git-send-email-nsekhar@ti.com> <1331469972-2638-2-git-send-email-nsekhar@ti.com>
Date: Mon, 12 Mar 2012 11:51:35 -0600
Message-Id: <20120312175135.2BDB53E07B0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 18:16:11 +0530, Sekhar Nori <nsekhar@ti.com> wrote:
> Unbanked GPIO irq setup code was overwriting chip_data leading
> to the following oops on request_irq()
> 
> Unable to handle kernel paging request at virtual address febfffff
[...]
> Fix the issue.

Applied, but for next time "Fix the issue" isn't the most helpful commit text.
Please describe *how* you fixed the issue so that future commit readers have
more clues as to what this patch is doing.

g.

