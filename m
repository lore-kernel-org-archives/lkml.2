Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0ECTLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:11:44 -0400
Received: from kroah.org ([198.145.64.141]:49362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab0ECTLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:11:38 -0400
Date: Mon, 3 May 2010 11:49:37 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bob Beers <bob.beers@gmail.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: cxt1e1: Fix build error
Message-ID: <20100503184937.GA10877@kroah.com>
References: <1272815813.16886.5.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1272815813.16886.5.camel@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 02, 2010 at 11:56:53AM -0400, Javier Martinez Canillas wrote:
> With today linux-next I got this compilation error:
> 
> drivers/staging/cxt1e1/linux.c: In function ‘c4_add_dev’:
> drivers/staging/cxt1e1/linux.c:1195: error: ‘struct net_device’ has no member named ‘priv’
> 
> I think this patch solves the issue

It does, but Randy Dunlap sent this fix in on Friday and I applied it
already :(

thanks,

greg k-h
