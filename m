Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855Ab1EYNgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:36:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932805Ab1EYNf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:35:56 -0400
Date: Wed, 25 May 2011 15:35:55 +0200
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
 tristate options
Message-ID: <20110525133555.GG2276@sepie.suse.cz>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 05:35:32PM +0200, Michal Marek wrote:
> For strings and integers, the config_is_xxx macros are useless and
> sometimes misleading:
> 
>   #define CONFIG_INITRAMFS_SOURCE ""
>   #define config_is_initramfs_source() 1
> 
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/kconfig/confdata.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)

I applied this to kbuild-2.6.git#kconfig, but I won't be sending this
and the config_is_xxx patch to Linus now. First, I'm a bit in hurry and
there have been proposals for either a different name of the macro, or a
different implementation, second, the fixdep fix is not here, so we
wouldn't be able to make use of the feature anyway. So let's settle on a
final solution for 2.6.41 or 3.1 or whatever comes second next.

Michal
