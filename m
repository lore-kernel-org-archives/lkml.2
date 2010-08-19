Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab0HSVtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 17:49:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970Ab0HSVt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 17:49:29 -0400
Date: Thu, 19 Aug 2010 14:49:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: make dev_to_mmc_card() macro public
Message-Id: <20100819144921.40d6765f.akpm@linux-foundation.org>
In-Reply-To: <1282138278-22304-1-git-send-email-ext-andriy.shevchenko@nokia.com>
References: <1282138278-22304-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Aug 2010 16:31:18 +0300
Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> Conversion from struct device to struct mmc_card is used more than in one
> place. Due to this it's better to have public macro for such thing.
> 

nit: generally, subsystem-specific identifiers should use their
subsystem's identifier as a prefix.  So a better name for
dev_to_mmc_card() would be mmc_dev_to_card().  

