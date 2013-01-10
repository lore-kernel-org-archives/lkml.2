Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab3AJHxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 02:53:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53396 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3AJHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 02:53:50 -0500
Date: Wed, 09 Jan 2013 23:53:49 -0800 (PST)
Message-Id: <20130109.235349.2198186690882677527.davem@davemloft.net>
To: dan.carpenter@oracle.com
Cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] bnx2x: NULL dereference on error in debug code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130108134213.GA23742@elgon.mountain>
References: <20130108134213.GA23742@elgon.mountain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 8 Jan 2013 16:42:14 +0300

> "vfop" is NULL here.  I've changed the debugging to not use it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks Dan.
