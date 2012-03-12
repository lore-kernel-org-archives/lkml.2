Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2CLTvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:51:10 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50584 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab2CLTvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:51:08 -0400
Date: Mon, 12 Mar 2012 12:51:02 -0700 (PDT)
Message-Id: <20120312.125102.65764809953128692.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: kys@microsoft.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH 1/2] net/hyperv: Fix data corruption in
 rndis_filter_receive()
From: David Miller <davem@davemloft.net>
In-Reply-To: <A1F3067C9B68744AA19F6802BAB8FFDC0DCE4044@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1331328437-26852-1-git-send-email-haiyangz@microsoft.com>
	<20120311.155111.1595145426893784653.davem@davemloft.net>
	<A1F3067C9B68744AA19F6802BAB8FFDC0DCE4044@TK5EX14MBXC223.redmond.corp.microsoft.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Mar 2012 12:51:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 12 Mar 2012 15:39:02 +0000

> And, thanks for the reminder, I will specify the target tree in future submissions.

You still have to formally resubmit these patches, with the proper
indication of where the patches go.  Just replying to my complaint
with an answer won't make your patches get replied, as I've completely
dropped this submission.
