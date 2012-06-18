Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2FROBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:01:11 -0400
Received: from londo.lunn.ch ([80.238.139.98]:48434 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab2FROBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:01:07 -0400
Date: Mon, 18 Jun 2012 16:01:01 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Jamie Lentin <jm@lentin.co.uk>, Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH RFT] watchdog: Convert orion_wdt driver to watchdog core
Message-ID: <20120618140101.GP4799@lunn.ch>
References: <1339744964.20824.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339744964.20824.5.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 03:22:44PM +0800, Axel Lin wrote:
> Convert the orion_wdt driver to the watchdog framework API.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Hi Axel

Tested-by: Andrew Lunn <andrew@lunn.ch>

Note that both kirkwood and Orion5x watchdogs are currently broken.  I
will post a fix for that next. Once fixed, your changes to use the
framework API work O.K. for me.

	  Andrew
