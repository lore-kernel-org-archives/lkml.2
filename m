Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab0D3SQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:16:11 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58771 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759131Ab0D3SPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:15:15 -0400
Date: Fri, 30 Apr 2010 14:14:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/10] drivers: wireless: use new hex_to_bin() method
Message-ID: <20100430181451.GE4120@tuxdriver.com>
References: <cover.1272617852.git.ext-andriy.shevchenko@nokia.com>
 <e1305499edede753c119de13fb1536387cb73532.1272617852.git.ext-andriy.shevchenko@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1305499edede753c119de13fb1536387cb73532.1272617852.git.ext-andriy.shevchenko@nokia.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 12:34:08PM +0300, Andy Shevchenko wrote:
> Instead of using own implementation involve hex_to_bin() function.
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
