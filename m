Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2GQCFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:05:25 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43554 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2GQCFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:05:23 -0400
Date: Mon, 16 Jul 2012 19:05:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: devel@driverdev.osuosl.org, b-cousson@ti.com, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, kbaidarov@dev.rtsoft.ru,
        grant.likely@secretlab.ca
Subject: Re: [PATCHv4 0/4] staging: adding OMAP bandgap driver
Message-ID: <20120717020519.GA20277@kroah.com>
References: <1342108952-12987-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342108952-12987-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 07:02:28PM +0300, Eduardo Valentin wrote:
> Greg,
> 
> Here is again the OMAP BG driver, under staging area.
> I fixed the compilation issue I didn't see, wrt implicit function
> declarations. As I mentioned on other thread, my compilation test
> didn't see it, that's why I thought it was fine to send it.
> 
> I also limited the driver compilation to OMAP4/5.

I edited the Makefile part of the patch by hand, and applied these
patches, can you pull my tree and verify that I didn't break anything?

thanks,

greg k-h
