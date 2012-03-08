Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2CHVxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:53:10 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38801 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab2CHVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:53:06 -0500
Date: Thu, 08 Mar 2012 13:52:46 -0800 (PST)
Message-Id: <20120308.135246.1582619301405301344.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: bpoirier@suse.de, ccaulfie@redhat.com, teigland@redhat.com, sri@us.ibm.com,
        cluster-devel@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] dlm: Do not allocate a fd for peeloff
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F5911B1.6050600@hp.com>
References: <1331222159-28980-1-git-send-email-bpoirier@suse.de>
	<1331222159-28980-2-git-send-email-bpoirier@suse.de>
	<4F5911B1.6050600@hp.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 08 Mar 2012 13:52:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 08 Mar 2012 15:08:17 -0500

> On 03/08/2012 10:55 AM, Benjamin Poirier wrote:
>> avoids allocating a fd that a) propagates to every kernel thread and
>> usermodehelper b) is not properly released.
>> 
>> References: http://article.gmane.org/gmane.linux.network.drbd/22529
>> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> 
> Looks much better.

Also applied to net-next, thanks.
