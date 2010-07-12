Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0GLUVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:21:07 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56075 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0GLUVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:21:04 -0400
Date: Mon, 12 Jul 2010 14:21:01 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>
cc: linux-omap@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OMAP2: powerdomain: Add break in switch statement
In-Reply-To: <1278661253-22185-1-git-send-email-weber@corscience.de>
Message-ID: <alpine.DEB.2.00.1007121418220.10106@utopia.booyaka.com>
References: <1278661253-22185-1-git-send-email-weber@corscience.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jul 2010, Thomas Weber wrote:

> Add a missing break at end of switch statement. At the moment it is a
> fall through to WARN_ON(1) and return -EEXIST.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>

Thanks Thomas.

Tony, this is

Acked-by: Paul Walmsley <paul@pwsan.com>

if you want it for .36; otherwise, can queue it for .37 here.


- Paul
