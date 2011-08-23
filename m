Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1HWN16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 09:27:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49862 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab1HWN1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 09:27:52 -0400
Date: Tue, 23 Aug 2011 17:27:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] power_supply: fix sysfs format warning
Message-ID: <20110823132746.GA1352@oksana.dev.rtsoft.ru>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
 <20110822113047.b84e56e2.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110822113047.b84e56e2.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:30:47AM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix format warning:
> 
> drivers/power/power_supply_sysfs.c:82: warning: format '%d' expects type 'int', but argument 4 has type 'ssize_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---

Applied, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
