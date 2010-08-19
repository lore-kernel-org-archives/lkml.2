Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab0HSX7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:59:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51111
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877Ab0HSX7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:59:35 -0400
Date: Thu, 19 Aug 2010 16:59:51 -0700 (PDT)
Message-Id: <20100819.165951.200388018.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-08-19
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100819174638.GC2672@tuxdriver.com>
References: <20100819174638.GC2672@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 19 Aug 2010 13:46:38 -0400

> This collection of fixes intended for 2.6.36 includes a few that look
> bigger than they really are.  The one from Joe Perches corrects a number
> of inadvertant upper->lower case conversion from an earlier patch
> already in 2.6.36.  The ones from Wey-Yi Guy change a timer value in a
> number of device-dependent data structures in order to avoid excessive
> firmware resets for those devices.
> 
> In addition to those, the one from Johannes Berg gives iwl3945 its own
> filter flag function since sharing the iwlagn version has created
> regressions for iwl3945.  The one from me corrects a DMA API misuse in
> ipw2100 that results in warning backtraces.
> 
> Please let me know if there are problems!

Pulled, thanks.
