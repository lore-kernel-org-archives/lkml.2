Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0IBBRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:17:35 -0400
Received: from kroah.org ([198.145.64.141]:43874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0IBBRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:17:34 -0400
Date: Wed, 1 Sep 2010 18:02:36 -0700
From: Greg KH <greg@kroah.com>
To: Masayuki Ohtak <masa-korg@dsn.okisemi.com>
Cc: meego-dev@meego.com, LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
        yong.y.wang@intel.com, qi.wang@intel.com,
        andrew.chih.howe.khor@intel.com, arjan@linux.intel.com,
        alan@linux.intel.com, margie.foster@intel.com,
        Tomoya MORINAGA <morinaga526@dsn.okisemi.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_PHUB driver to 2.6.35
Message-ID: <20100902010236.GA21782@kroah.com>
References: <4C7E441E.4090006@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Nope, I still get a warning with this patch, but I'll go fix it up:
  CC [M]  drivers/misc/pch_phub.o
drivers/misc/pch_phub.c: In function ‘pch_phub_probe’:
drivers/misc/pch_phub.c:582:334: warning: cast from pointer to integer of different size
drivers/misc/pch_phub.c:585:2: warning: passing argument 2 of ‘pci_map_rom’ from incompatible pointer type
include/linux/pci.h:803:43: note: expected ‘size_t *’ but argument is of type ‘unsigned int *’
drivers/misc/pch_phub.c:592:346: warning: cast from pointer to integer of different size

thanks,

greg k-h
