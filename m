Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1HERx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:53:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62071 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab1HERx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:53:26 -0400
Date: Fri, 5 Aug 2011 20:53:14 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>
Subject: Re: [RFC PATCH v2] watchdog: ep93xx: Use the WatchDog Timer Driver
 Core.
Message-ID: <20110805175314.GA2451@mwesterb-mobl.ger.corp.intel.com>
References: <201108031021.26620.hartleys@visionengravers.com>
 <20110804181244.GA2445@mwesterb-mobl.ger.corp.intel.com>
 <ADE657CA350FB648AAC2C43247A983F001F3882B8D51@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F3882B8D51@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 04:54:56PM -0500, H Hartley Sweeten wrote:
> 
> I just posted a v3 of this patch that includes the Kconfig change to
> select WATCHDOG_CORE.  Can you please take a look and possibly test it?

Just checked v3, looks good to me. I also tested it on my TS-7260 and it works
well.

> After that I'll add your Tested-by and Reviewed-by tags.

Yes, please :-)
