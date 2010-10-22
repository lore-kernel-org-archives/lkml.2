Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0JVGEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 02:04:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab0JVGET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 02:04:19 -0400
Date: Thu, 21 Oct 2010 23:04:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, kok.howg.ewe@intel.com,
        joel.clark@intel.com, yong.y.wang@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [PATCH v4] Topcliff: Update PCH_GPIO driver to 2.6.35
Message-Id: <20101021230404.8520a485.akpm@linux-foundation.org>
In-Reply-To: <4CC1267D.50301@dsn.okisemi.com>
References: <4CC1267D.50301@dsn.okisemi.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 14:51:57 +0900 Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com> wrote:

> We want a GPIO maintainer to merge to 2.6.37.
> We got "Reviewed-by" for this patch.
> But I heard gpio tree is pretty much orphaned at the minute.
> Could you merge this patch to 2.6.37 ?

Sure.  The patch was rather nastily space-stuffed and word-wrapped by
your email client.  I fixed that up.  It otherwise looks OK to me.

