Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2A3Ohi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 09:37:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2A3Ohh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 09:37:37 -0500
Date: Mon, 30 Jan 2012 06:33:59 -0800
From: Greg KH <gregkh@suse.de>
To: Andrea Shepard <andrea@persephoneslair.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, khc@pm.waw.pl,
        davem@davemloft.net, mmarek@suse.cz, jkosina@suse.cz, joe@perches.com,
        justinmattock@gmail.com, alan@linux.intel.com, jdmason@kudzu.us
Subject: Re: [02/22] Cyclades PC300 driver: re-enable Kconfig option
Message-ID: <20120130143359.GA13388@suse.de>
References: <20120130024446.GC10262@cronus.persephoneslair.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130024446.GC10262@cronus.persephoneslair.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 06:44:46PM -0800, Andrea Shepard wrote:
> The old pc300 driver had been disabled because it did not build.  This patch
> re-enables it in Kconfig.

But isn't the build still broken at this point in time?

