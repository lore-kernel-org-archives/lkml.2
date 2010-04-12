Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0DLJnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:43:39 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:5317 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab0DLJni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:43:38 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAOIwkvCTtAn/2dsb2JhbACbMnG5OIUMBINC
Date: Mon, 12 Apr 2010 11:43:28 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       John Nicholls <john@thinlinx.com>, Rick Bronson <rick@efn.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       michael trimarchi <michael@evidence.eu.com>, rmk@arm.linux.org.uk,
       hskinnemoen@atmel.com, linux@maxim.org.za
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
Message-ID: <20100412094328.GA18182@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 08:28:49AM +0000, Alan Cox wrote:
> 
> > Thank you for the feedback.
> >
> > Let me know if this new version solves the above problems.
> 
> Looks good to me. Thanks for the quick clean up.

Could someone add somewhere (Documentation, or usr/include/linux/serial.h)
a precise documentation of how this is to be used from user-space,
and implemented in other drivers ?

Philippe
