Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2ICTyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 15:54:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44256 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2ICTyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 15:54:45 -0400
Date: Mon, 3 Sep 2012 21:54:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Rupesh Gujare <rgujare@ozmodevices.com>
Cc: Andi Kleen <andi@firstfloor.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org, ckelly@ozmodevices.com
Subject: Re: [PATCH] staging/ozwpan: Fix zero address check in oz_set_active_pd
Message-ID: <20120903195439.GY16230@one.firstfloor.org>
References: <20120903191721.GX16230@one.firstfloor.org> <5045077F.80700@ozmodevices.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5045077F.80700@ozmodevices.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Its already fixed by this patch :-
> 
> http://driverdev.linuxdriverproject.org/pipermail/devel/2012-August/029734.html

Should be in 3.6 then as it's a bug fix.

-Andi
