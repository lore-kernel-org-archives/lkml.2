Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0IPTwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:52:05 -0400
Received: from kroah.org ([198.145.64.141]:39102 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab0IPTwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:52:02 -0400
Date: Thu, 16 Sep 2010 12:32:49 -0700
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCHv2 01/10] staging: rt2860: change plain format of mac
 address to %pM in *printf()
Message-ID: <20100916193249.GD10397@kroah.com>
References: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ad2522ae82e753fcfa9fa9726d2a301e7b8b987.1284316733.git.andy.shevchenko@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 11:40:25AM +0300, Andy Shevchenko wrote:
> There are many locations where MAC or BSSID is printed. The plain format
> is used in such places. *printf() in kernel recognizes
> %pM, %pMF and %pm format parameters to print out 6-byte array as MAC
> address. This patch changes plain format to custom %pM which is widely
> used in kernel.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>

<snip>

Oops, I just took your first version of this series.  Was there any
differences?  If so, care to send me the remaining pieces and I'll apply
them?

thanks,

greg k-h
