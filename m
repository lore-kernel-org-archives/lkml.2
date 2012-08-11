Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2HKUvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:51:32 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35317 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab2HKUuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:50:55 -0400
Date: Sat, 11 Aug 2012 13:50:44 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: <cjren@qca.qualcomm.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <qca-linux-team@qualcomm.com>,
        <nic-devel@qualcomm.com>, Xiong Huang <xiong@qca.qualcomm.com>,
        "Hao-Ran Liu(Joseph Liu)" <hao-ran.liu@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
Message-ID: <20120811135044.529a7081@nehalam.linuxnetplumber.net>
In-Reply-To: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
References: <1344507270-2907-1-git-send-email-cjren@qca.qualcomm.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012 18:14:30 +0800
<cjren@qca.qualcomm.com> wrote:

> +	strcpy(netdev->name, "eth%d");
> +	retval = register_netdev(netdev);

The strcpy is unnecessary, alloc_etherdev already sets that.
