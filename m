Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab0FRTQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:16:49 -0400
Received: from kroah.org ([198.145.64.141]:47385 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab0FRTQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:16:48 -0400
Date: Fri, 18 Jun 2010 12:16:42 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [STAGING] Spectra Flash Translation Layer
Message-ID: <20100618191642.GA23428@kroah.com>
References: <1276019010.22896.13.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1276019010.22896.13.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 06:43:30PM +0100, David Woodhouse wrote:
> Greg, please pull from
> 	git://git.infradead.org/users/dwmw2/spectra-2.6.git
> 
> This was previously known as the 'Moorestown NAND flash driver'.

Now pulled.

Note I do get some warnings when building the code:

drivers/staging/spectra/ffsport.c:116:0: warning: "GLOB_VERSION" redefined
drivers/staging/spectra/spectraswconfig.h:24:0: note: this is the location of the previous definition
drivers/staging/spectra/flash.c: In function ‘dump_cache_l2_table’:
drivers/staging/spectra/flash.c:778:9: warning: unused variable ‘i’
drivers/staging/spectra/flash.c: At top level:
drivers/staging/spectra/flash.c:2015:12: warning: ‘FTL_Cache_Write_Back’ defined but not used
drivers/staging/spectra/flash.c:2396:13: warning: ‘FTL_Format_Flash’ defined but not used

Are those to be expected?

thanks,

greg k-h
