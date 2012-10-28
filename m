Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2J1Mys (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 08:54:48 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:59221 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2J1Myr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 08:54:47 -0400
Message-ID: <508D2B15.2050601@tilera.com>
Date: Sun, 28 Oct 2012 08:54:45 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/16] tile: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
References: <cover.1351411047.git.joe@perches.com> <c7c947ee63de15e20b7a7e2f47aee66ef02ca50f.1351411047.git.joe@perches.com>
In-Reply-To: <c7c947ee63de15e20b7a7e2f47aee66ef02ca50f.1351411047.git.joe@perches.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 4:05 AM, Joe Perches wrote:
> dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
> and reducing object size is good.
> Coalesce formats for easier grep.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/tile/kernel/pci_gx.c |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

