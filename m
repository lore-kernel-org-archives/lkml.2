Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab0ERUBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:01:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171Ab0ERUBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:01:13 -0400
Date: Tue, 18 May 2010 12:56:24 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, dwmw2@infradead.org,
       broonie@opensource.wolfsonmicro.com, len.brown@intel.com,
       astarikovskiy@suse.de, mreimer@vpop.net, zbr@ioremap.net, tj@kernel.org,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 2/3] pda_power: add support for writeable properties
Message-ID: <20100518195624.GA20057@suse.de>
References: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
 <1274212193-16669-2-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274212193-16669-2-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 09:49:52PM +0200, Daniel Mack wrote:
> This patch adds support for writeable power supply properties and
> exposes them as writeable to sysfs.

Please properly document this in Documentation/ABI as you are changing
the userspace ABI.

thanks,

greg k-h
