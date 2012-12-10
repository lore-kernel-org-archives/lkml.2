Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab2LJRYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:24:05 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:43255 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2LJRYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:24:03 -0500
Date: Mon, 10 Dec 2012 17:24:01 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Roger Quadros <rogerq@ti.com>
cc: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com,
        keshava_mgowda@ti.com, sshtylyov@mvista.com, bjorn@mork.no,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: Re: [PATCH v4 21/23] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
In-Reply-To: <1355134833-5199-22-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.00.1212101723490.1982@utopia.booyaka.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com> <1355134833-5199-22-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012, Roger Quadros wrote:

> We don't need multiple aliases for the OMAP USB host clocks and neither
> the dummy clocks so remove them.
> 
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Rajendra Nayak <rnayak@ti.com>
> CC: Benoit Cousson <b-cousson@ti.com>
> CC: Mike Turquette <mturquette@gmail.com>
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Paul Walmsley <paul@pwsan.com>


- Paul
