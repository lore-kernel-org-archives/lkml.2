Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2JWOIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:08:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:49357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932992Ab2JWOIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="209486825"
Date: Tue, 23 Oct 2012 22:07:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH -next] printk: fix broken 'console' kernel parameter
Message-ID: <20121023140749.GA21823@localhost>
References: <1350999678-17441-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350999678-17441-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 09:41:18PM +0800, Ming Lei wrote:
> If CONFIG_A11Y_BRAILLE_CONSOLE is not enabled, _braille_console_setup()
> should return NULL to parse the parameter further in console_setup().
> 
> This patch fixes the broken 'console' kernel parameter, which makes the
> Pandaboard not boot with 'console=ttyO2'.

Not sure if this is related, but I got an early crash with linux-next and
the first bad commit is

commit 10db96eb4942a011a76de8c98aabc4f132a882d9
Author: Joe Perches <joe@perches.com>
Date:   Tue Oct 23 13:50:17 2012 +1100

    printk: move braille console support into separate braille.[ch]
    files

Thanks,
Fengguang
