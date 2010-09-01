Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0IAXJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:09:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab0IAXJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:09:09 -0400
Date: Wed, 1 Sep 2010 16:09:01 -0700
From: Greg KH <gregkh@suse.de>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        alan@linux.intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100901230901.GA21326@suse.de>
References: <4C7E441E.4090006@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C7E441E.4090006@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 09:16:30PM +0900, Masayuki Ohtak wrote:
> Hi Greg,
> 
> Sorry, we have modified again, for a bug(illegal return code) and
> WARNING for building with the latest kernel.
> 
> Please check below.

Looks good.  Do you want me to queue it up for the .37 kernel merge
through my tree, or through someone elses?

thanks,

greg k-h
