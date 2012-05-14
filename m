Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2ENMbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:31:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37027 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2ENMbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:31:01 -0400
Date: Mon, 14 May 2012 13:30:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, horms@verge.net.au,
        olof@lixom.net
Subject: Re: [PATCH 03/03] ARM: Undelete KZM9D mach-type
Message-ID: <20120514123034.GD10453@n2100.arm.linux.org.uk>
References: <20120514105424.8596.38355.sendpatchset@w520> <20120514105451.8596.92367.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120514105451.8596.92367.sendpatchset@w520>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 07:54:51PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Undelete the KZM9D mach-type to allow build of board
> for EMEV2 SoC support.

If you've converted to use DT for KZM9D, do you still need this?
