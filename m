Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab0CTUIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:08:51 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:55560 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0CTUIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:08:49 -0400
Date: Sat, 20 Mar 2010 22:09:07 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 03/24] usb/otg/isp1301_omap: Fix dangling pointer
Message-ID: <20100320200907.GA3861@gandalf>
Reply-To: me@felipebalbi.com
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
 <1269094385-16114-4-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269094385-16114-4-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 03:12:44PM +0100, Wolfram Sang wrote:
> Fix this i2c-driver which missed setting clientdata to NULL before freeing the
> structure it points to. Found by a semantic patch, but fixed by hand.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

Acked-by: Felipe Balbi <felipe.balbi@nokia.com>

Greg,

if you wish, you can take queue it already unless Dave has any comments.

-- 
balbi
