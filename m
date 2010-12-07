Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab0LGTPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:15:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51660 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0LGTPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:15:10 -0500
Date: Tue, 7 Dec 2010 14:05:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        ath9k-devel@venema.h4ckr.net, Peter Stuge <peter@stuge.se>,
        Felix Fietkau <nbd@openwrt.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] ath: logging message conversion
Message-ID: <20101207190528.GD2700@tuxdriver.com>
References: <20101202190239.GE7399@tux>
 <cover.1291333543.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1291333543.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 07:12:34PM -0800, Joe Perches wrote:
> ath_print is misleading as it's only used with CONFIG_ATH_DEBUG.
> 
> Add and use the more normal <subsystem>_printk and <subsystem>_<level>
> printk equivalents. (ath_printk and ath_<level>)
> 
> Fix various defects in the current uses of ath_print formats
> and arguments: Unnecessary casts, missing newlines, multiple
> prints, and 1 loop which can exceed array bounds.
> 
> Bundled and integrated the individual patches into a single patch series.
> 
> Joe Perches (4):
>   ath: Add and use ath_printk and ath_<level>
>   ath: Convert ath_print(.., ATH_DBG_FATAL to ath_err
>   ath: Convert ath_print to ath_dbg
>   ath: Fix ath_dbg access beyond array bound

Is the Atheros crew happy with this series?  They didn't seem to like
the original patches very much...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
