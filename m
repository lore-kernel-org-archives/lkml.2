Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055Ab2ILSPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:15:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49454 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760946Ab2ILSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:15:09 -0400
Date: Wed, 12 Sep 2012 11:15:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, arnd@arndb.de,
        dhowells@redhat.com, fenghua.yu@intel.com, lethal@linux-sh.org,
        linux@arm.linux.org.uk, nico@linaro.org, rob.herring@calxeda.com,
        tony.luck@intel.com, tony@atomide.com, will.deacon@arm.com
Subject: Re: [PATCH v2] /dev/mem: use phys_addr_t for physical addresses
Message-ID: <20120912181503.GB12840@kroah.com>
References: <1347473158-7219-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347473158-7219-1-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 02:05:58PM -0400, Cyril Chemparathy wrote:
> This patch fixes the /dev/mem driver to use phys_addr_t for physical
> addresses.  This is required on PAE systems, especially those that run
> entirely out of >4G physical memory space.

What is the symptom if this patch is not applied?  Does it need to be
backported to older kernels?  If so, which ones?

thanks,

greg k-h
