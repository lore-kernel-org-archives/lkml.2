Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2LQUwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 15:52:09 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:39402 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab2LQUwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 15:52:07 -0500
Date: Mon, 17 Dec 2012 20:52:06 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: OMAP4: PRM: Correct reset source map
In-Reply-To: <1355776640-369-1-git-send-email-ivan.khoronzhuk@ti.com>
Message-ID: <alpine.DEB.2.00.1212172050290.29833@utopia.booyaka.com>
References: <1355776640-369-1-git-send-email-ivan.khoronzhuk@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, 17 Dec 2012, Ivan Khoronzhuk wrote:

> In the map for reset sources register we use defines intended for
> using with PRM_RSTCTRL register. So fix it.

your changes look good, but they are missing Signed-off-by: lines.  Could 
you please either resend with those, or confirm that you intended to add 
them?  You may wish to read Documentation/SubmittingPatches, particularly 
item 12.


- Paul
