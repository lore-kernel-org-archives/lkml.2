Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0LQSQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:16:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37713
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755396Ab0LQSQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:16:08 -0500
Date: Fri, 17 Dec 2010 10:16:36 -0800 (PST)
Message-Id: <20101217.101636.104051313.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: joe.jin@oracle.com, baum@tehutinetworks.net, andy@greyhouse.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        guru.anbalagane@oracle.com, greg.marsden@oracle.com,
        zhenzhong.duan@oracle.com, jaswinder@infradead.org
Subject: Re: [PATCH net-2.6] tehuti: Firmware filename is tehuti/bdx.bin
From: David Miller <davem@davemloft.net>
In-Reply-To: <1292595184.3136.843.camel@localhost>
References: <1292595184.3136.843.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 17 Dec 2010 14:13:03 +0000

> My conversion of tehuti to use request_firmware() was confused about
> the filename of the firmware blob.  Change the driver to match the
> blob.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

Applied and queued up for -stable, thanks.
