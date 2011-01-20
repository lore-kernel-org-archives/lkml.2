Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab1ATIHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:07:16 -0500
Received: from lo.gmane.org ([80.91.229.12]:60389 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab1ATIHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:07:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: Checkpatch problem with Kconfig help symbol ?
Date: Thu, 20 Jan 2011 08:06:59 +0000 (UTC)
Message-ID: <ih8qf2$41t$3@dough.gmane.org>
References: <1295440968.2276.46.camel@dell>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011 14:42:48 +0200, Tapio Vihuri wrote:

> Hi
> 
> Is this false positive ?
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #60: FILE: drivers/input/misc/Kconfig:159: +       help
> 
> 
> Interesting enough, also:
> 
> ./scripts/checkpatch.pl --file drivers/input/misc/Kconfig WARNING:
> please write a paragraph that describes the config symbol fully #430:
> FILE: input/misc/Kconfig:430:
> +       help
> 
> 
> But this is different line.
> 

Seems yes, the Kconfig part of your patch looks fine.

