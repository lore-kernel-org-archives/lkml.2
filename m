Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571Ab2IGLaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:30:00 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:52568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2IGL35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:29:57 -0400
Message-ID: <1347017428.4256.11.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH 8/10] net/mac80211/scan.c: removes unnecessary semicolon
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Sep 2012 13:30:28 +0200
In-Reply-To: <1346947757-10481-9-git-send-email-peter.senna@gmail.com> (sfid-20120906_180946_737330_4FA8D7B3)
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
	 <1346947757-10481-9-git-send-email-peter.senna@gmail.com>
	 (sfid-20120906_180946_737330_4FA8D7B3)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 18:09 +0200, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> removes unnecessary semicolon
> 
> Found by Coccinelle: http://coccinelle.lip6.fr/

Applied. It'd be nice to have the spatch, I guess :)

johannes

