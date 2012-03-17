Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030544Ab2CQFYD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 01:24:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:39531 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030188Ab2CQFX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 01:23:58 -0400
Date: Fri, 16 Mar 2012 22:23:52 -0700 (PDT)
Message-Id: <20120316.222352.1067507516750800594.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: sony.chacko@qlogic.com, rajesh.borundia@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/3 v3] netxen: qlogic ethernet : Fix endian bug.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1331629104-3283-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1331629104-3283-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 16 Mar 2012 22:23:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Tue, 13 Mar 2012 14:28:24 +0530

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Change the datatype of "ip_addr" to __be32 as 'ip' should be in
> big endian format.
> 
> Adapter needs "ip address" in big endian format stored at lower 32bit
> of req.word[1]. netxen_config_ipaddr() now receives 'ip' in big endian
> format. To satisfy adapter's need, use memcpy() to copy byte by byte
> of 'ip' into lower 32bit of req.word[1].
> 
> Mac address and serial number of adapter need to be in little endian format.
> Change the data type of the related  variables to __le32 / __le64 or cast it
> explicitly to __le32 / __le64 depending upon the requirement.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

Applied.
