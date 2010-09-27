Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab0I0DE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 23:04:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab0I0DEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 23:04:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: William Immendorf <will.immendorf@gmail.com>
Subject: Re: [PATCH] vmscan: raise the bar to PAGEOUT_IO_SYNC stalls
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <AANLkTimKZdD1DjymuhwKCtrraK2QwBOw5XUo0HBnQPKv@mail.gmail.com>
References: <AANLkTimKZdD1DjymuhwKCtrraK2QwBOw5XUo0HBnQPKv@mail.gmail.com>
Message-Id: <20100927120641.6B3F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 27 Sep 2010 12:04:45 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a backport of Upstream commit e31f3698cd3499e676f6b0ea12e3528f569c4fa3.
> Originally submitted by Wu Fengguang. The rest of the message is his.
> I think this would be a good canadate for the stable tree.

We already did :)


