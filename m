Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2BXOA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 09:00:29 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:63641 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab2BXOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 09:00:28 -0500
Date: Fri, 24 Feb 2012 15:00:25 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] xscale/ixp2000/ixpdev: print MAC via printk format
 specifier
Message-ID: <20120224140025.GP29303@wantstofly.org>
References: <1330091162-8141-1-git-send-email-danny.kukawka@bisect.de>
 <1330091162-8141-8-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330091162-8141-8-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 02:45:58PM +0100, Danny Kukawka wrote:

> Print MAC/dev_addr via printk extended format specifier %pM
> instead of custom code.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

Acked-by: Lennert Buytenhek <kernel@wantstofly.org>
