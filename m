Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1BNVMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 16:12:30 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:38396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1BNVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 16:12:29 -0500
Subject: Re: pull request: wireless-2.6 2011-02-14
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110214.130056.115934219.davem@davemloft.net>
References: <20110214204406.GG2722@tuxdriver.com>
	 <20110214.125148.59672184.davem@davemloft.net>
	 <20110214.130056.115934219.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 22:12:22 +0100
Message-ID: <1297717942.3953.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 13:00 -0800, David Miller wrote:

> Please address this newly introduced warning in a future pull request,
> thanks:
> 
> drivers/net/wireless/iwlwifi/iwl-3945.c:411:13: warning: 'iwl3945_good_plcp_health' defined but not used

The function can simply be deleted.

johannes

