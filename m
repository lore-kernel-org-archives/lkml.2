Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473Ab2C2Pir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:38:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50285 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2C2Pim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120209185043.GA12089@joshcartwright.net>
References: <20120209185043.GA12089@joshcartwright.net>
Date: Thu, 29 Mar 2012 08:38:41 -0700
Message-ID: <CAN8TOE-9fxbc8PM8oNVBc_tUdkYBhV6jTG8_M5GdjLNGpLhKKA@mail.gmail.com>
Subject: Re: [PATCH] jffs2: Fix lock acquisition order bug in gc path
From: Brian Norris <computersforpeace@gmail.com>
To: Josh Cartwright <joshc@linux.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 10:50 AM, Josh Cartwright <joshc@linux.com> wrote:
> The locking policy is such that the erase_complete_block spinlock is
> nested within the alloc_sem mutex.  This fixes a case in which the
> acquisition order was erroneously reversed.  This issue was caught by
> the following lockdep splat:

(Bump.) Anybody interested in this patch? It seemed sane to me, and I
had it sitting in my inbox. It does need a trivial rebase, BTW.

Brian
