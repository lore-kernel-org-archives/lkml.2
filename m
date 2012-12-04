Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab2LDIRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 03:17:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:19461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab2LDIRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 03:17:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,213,1355126400"; 
   d="scan'208";a="256958935"
Date: Tue, 4 Dec 2012 10:17:13 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/5] serial: 8250_dw: Map IO memory
Message-ID: <20121204081713.GA8071@xps8300>
References: <1354533479-27306-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1354533479-27306-4-git-send-email-heikki.krogerus@linux.intel.com>
 <20121203154014.GA20140@page>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203154014.GA20140@page>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

On Mon, Dec 03, 2012 at 03:40:14PM +0000, Jamie Iles wrote:
> > +	uart.port.membase = ioremap(regs->start, regs->end - regs->start);
> 
> Doesn't this have an off-by-one error?

True.

> +	uart.port.membase = ioremap(regs->start, resource_size(regs));
> 
> instead?

Yes, I'll fix this. Thanks!

-- 
heikki
