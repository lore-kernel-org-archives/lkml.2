Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0FFJ4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:56:10 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:42538
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab0FFJ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:56:05 -0400
Date: Sun, 6 Jun 2010 11:56:41 +0200
From: Michael Guntsche <mike@it-loops.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: Re: [2.6.35-rc1] page alloc failure order:1, mode:0x4020
Message-ID: <20100606095640.GA4436@trillian.comsick.at>
References: <20100604092025.GA96690@trillian.comsick.at>
 <1275656014.2482.169.camel@edumazet-laptop>
 <20100604161644.GA98048@trillian.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604161644.GA98048@trillian.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010.06.04 18:16:44 , Michael Guntsche wrote:
> I applied the patch recompiled and run it on the routerboard, trying
> to trigger the bug again.

Hi Eric,

Up to now I was not able to reproduce the bug, do you think this patch
can be pushed to mainline or is there a "better"/other  fix for it?

Kind regards,
Michael


