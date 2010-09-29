Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0I2OTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:19:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0I2OTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:19:33 -0400
Date: Wed, 29 Sep 2010 16:19:31 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jean Sacren <sakiwit@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scripts: Enable error messages while hush up
 unnecessary warnings
Message-ID: <20100929141931.GA2055@sepie.suse.cz>
References: <20100911051053.GA18094@mail.gmail.com>
 <20100911051333.GA18189@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100911051333.GA18189@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 11:13:33PM -0600, Jean Sacren wrote:
> As no error was handled, we wouldn't be able to know when an error does
> occur. The fix preserves error messages while it doesn't let unnecessary
> compiling warnings show up.
> 
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> ---
>  scripts/kallsyms.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)

Thanks, applied.

Michal
