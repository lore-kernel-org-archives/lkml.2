Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0LGT0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:26:09 -0500
Received: from mail.atheros.com ([12.19.149.2]:61286 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab0LGT0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:26:08 -0500
Date: Tue, 7 Dec 2010 11:26:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>, Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        Peter Stuge <peter@stuge.se>, Felix Fietkau <nbd@openwrt.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath: logging message conversion
Message-ID: <20101207192604.GA2582@tux>
References: <20101202190239.GE7399@tux>
 <cover.1291333543.git.joe@perches.com>
 <20101207190528.GD2700@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101207190528.GD2700@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 11:05:28AM -0800, John W. Linville wrote:
> On Thu, Dec 02, 2010 at 07:12:34PM -0800, Joe Perches wrote:
> > ath_print is misleading as it's only used with CONFIG_ATH_DEBUG.
> > 
> > Add and use the more normal <subsystem>_printk and <subsystem>_<level>
> > printk equivalents. (ath_printk and ath_<level>)
> > 
> > Fix various defects in the current uses of ath_print formats
> > and arguments: Unnecessary casts, missing newlines, multiple
> > prints, and 1 loop which can exceed array bounds.
> > 
> > Bundled and integrated the individual patches into a single patch series.
> > 
> > Joe Perches (4):
> >   ath: Add and use ath_printk and ath_<level>
> >   ath: Convert ath_print(.., ATH_DBG_FATAL to ath_err
> >   ath: Convert ath_print to ath_dbg
> >   ath: Fix ath_dbg access beyond array bound
> 
> Is the Atheros crew happy with this series?  They didn't seem to like
> the original patches very much...

Its fine now that Joe has addressed some more important items.
But I'd like for the patches to be applied last of all pending
patches :)

  Luis
