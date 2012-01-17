Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab2AQPFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:05:04 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:54405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2AQPFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:05:02 -0500
Date: Tue, 17 Jan 2012 10:04:56 -0500 (EST)
Message-Id: <20120117.100456.580601879746362569.davem@davemloft.net>
To: cascardo@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ehea: make some functions and variables static
From: David Miller <davem@davemloft.net>
In-Reply-To: <1326477992-16229-1-git-send-email-cascardo@linux.vnet.ibm.com>
References: <1326477992-16229-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 07:04:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Date: Fri, 13 Jan 2012 16:06:32 -0200

> Some functions and variables in ehea are only used in their own file, so
> they should be static. One particular function had a very generic name,
> print_error_data.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

Applied, thanks.
