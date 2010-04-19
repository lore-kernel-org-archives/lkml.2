Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab0DSREl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:04:41 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:58653 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0DSREk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:04:40 -0400
Date: Mon, 19 Apr 2010 19:04:35 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Nguyen Dinh-R00091 <R00091@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, amit.kucheria@canonical.com,
       linux@arm.linux.org.uk, Herring Robert-RA7055 <RA7055@freescale.com>,
       Zhang Lily-R58066 <R58066@freescale.com>, linux-kernel@vger.kernel.org,
       grant.likely@secretlab.ca, Li Jun-R65092 <R65092@freescale.com>,
       valentin.longchamp@epfl.ch, bryan.wu@canonical.com,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4 2.6.34-rc4 5/7] mxc: Add generic USB HWinitialization
 for MX51
Message-ID: <20100419170435.GC30807@buzzloop.caiaq.de>
References: <1271445371-18501-1-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-2-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-3-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-4-git-send-email-Dinh.Nguyen@freescale.com>
 <1271445371-18501-5-git-send-email-Dinh.Nguyen@freescale.com>
 <20100418020726.GB7882@pengutronix.de>
 <86A0E76937111F4C92FABEC0A20988510473395C@az33exm21>
 <20100419155828.GE7882@pengutronix.de>
 <20100419165939.GB30807@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100419165939.GB30807@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 06:59:39PM +0200, Daniel Mack wrote:
> Think about what's necessary to add support for a new board. You don't
> want to copy all the register accessing functions again but re-use and
> share generic code. All you need to have in the board specific support
> code are flags which are passed to the generic driver core. Just like
> all other board support code does it as well. Not just for USB btw. but
> for all sorts of other drivers as wel. Have a look at code which is
> already there to get the idea.
> 
> [Btw - your mail client is broken as it wraps quoted lines (see above).
>  See Documentation/email-clients.txt]

Sorry, I messed up the To/Cc fields in my reply. The above was directed
to Nguyen Dinh of course, not to Sascha.

