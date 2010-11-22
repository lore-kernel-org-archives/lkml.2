Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab0KVVc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 16:32:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:58999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab0KVVcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:32:24 -0500
Date: Mon, 22 Nov 2010 13:31:38 -0800
From: Greg KH <gregkh@suse.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [35/45] USB: atmel_usba_udc: force vbus_pin at -EINVAL when
 gpio_request failled
Message-ID: <20101122213138.GB2881@suse.de>
References: <20101119214412.310478722@clark.site>
 <4CEA32F1.2030208@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEA32F1.2030208@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 10:08:01AM +0100, Nicolas Ferre wrote:
> Le 19/11/2010 22:43, Greg KH :
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> Hi Greg,
> 
> Please also add this typo one (or merge it): 
> 
> http://git.kernel.org/?p=linux/kernel/git/gregkh/usb-2.6.git;a=commit;h=b48809518631880207796b4aab0fc39c2f036754
> 
> Thanks a lot for monitoring this issue and adding to -stable...

I will get it in after it goes to Linus.

thanks,

greg k-h
