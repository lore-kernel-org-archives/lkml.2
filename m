Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2KGJ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:56:23 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33210 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566Ab2KGJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:56:21 -0500
Date: Wed, 7 Nov 2012 10:56:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: David Miller <davem@davemloft.net>
Cc: pebolle@tiscali.nl, linux-kernel@vger.kernel.org, isdn@linux-pingi.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 8/9] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
Message-ID: <20121107095616.GA13463@gmail.com>
References: <20121104105332.GC27124@gmail.com>
 <20121104.123013.700345271120279281.davem@davemloft.net>
 <20121105103126.GB5220@gmail.com>
 <20121106.185752.1986400393399264104.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121106.185752.1986400393399264104.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Nov 2012, David Miller wrote:

> From: Lee Jones <lee.jones@linaro.org>
> Date: Mon, 5 Nov 2012 11:31:26 +0100
> 
> > Does something like look like a better solution?
> > 
> > Author: Lee Jones <lee.jones@linaro.org>
> > Date:   Sat Nov 3 22:06:02 2012 +0100
> > 
> >     isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
> 
> Yes, it looks good, please resubmit it formally.

Done. Thanks for reviewing.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
