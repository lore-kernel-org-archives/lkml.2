Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593Ab2EKGzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:55:53 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50208 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab2EKGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:55:50 -0400
Date: Fri, 11 May 2012 15:55:46 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-sh@vger.kernel.org,
        johnstul@us.ibm.com, rjw@sisk.pl, lethal@linux-sh.org,
        gregkh@linuxfoundation.org, olof@lixom.net, tglx@linutronix.de
Subject: Re: [PATCH 00/03] clocksource: Emma Mobile STI V2 patches
Message-ID: <20120511065542.GC17741@verge.net.au>
References: <20120509143926.27521.20342.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509143926.27521.20342.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:39:26PM +0900, Magnus Damm wrote:
> clocksource: Emma Mobile STI V2 patches
> 
> [PATCH 01/03] clockevents: Make clockevents_config() a global symbol
> [PATCH 02/03] clocksource: em_sti: Emma Mobile STI driver V2

Patches 1 & 2.

Tested-by: Simon Horman <horms@verge.net.au>

> [PATCH 03/03] clocksource: em_sti: Add DT support

I am unsure how to exercise this code.
