Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab2CHVxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:53:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:38795 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870Ab2CHVw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:52:58 -0500
Date: Thu, 08 Mar 2012 13:52:35 -0800 (PST)
Message-Id: <20120308.135235.216702729705858755.davem@davemloft.net>
To: vladislav.yasevich@hp.com
Cc: bpoirier@suse.de, ccaulfie@redhat.com, teigland@redhat.com, sri@us.ibm.com,
        cluster-devel@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sctp: Export sctp_do_peeloff
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F59118C.9090605@hp.com>
References: <20120308.002447.1062706659978103072.davem@davemloft.net>
	<1331222159-28980-1-git-send-email-bpoirier@suse.de>
	<4F59118C.9090605@hp.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 08 Mar 2012 13:52:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladislav Yasevich <vladislav.yasevich@hp.com>
Date: Thu, 08 Mar 2012 15:07:40 -0500

> On 03/08/2012 10:55 AM, Benjamin Poirier wrote:
>> lookup sctp_association within sctp_do_peeloff() to enable its use outside of
>> the sctp code with minimal knowledge of the former.
>> 
>> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
>> 
> 
> Acked-by: Vlad Yasevich <vladislav.yasevich@hp.com>

Applied to net-next.
