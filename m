Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1HSRCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 13:02:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab1HSRC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 13:02:27 -0400
Date: Fri, 19 Aug 2011 21:02:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] power: max8998_charger.c needs module.h
Message-ID: <20110819170222.GM22761@oksana.dev.rtsoft.ru>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
 <20110729211143.0a9d6ed7.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110729211143.0a9d6ed7.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 09:11:43PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> power/max8998_charger.c uses interfaces from linux/module.h,
> so it should include that file.  This fixes build errors.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---

Applied, thank you!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
