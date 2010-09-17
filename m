Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab0IQEw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 00:52:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55176
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750818Ab0IQEwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 00:52:55 -0400
Date: Thu, 16 Sep 2010 21:53:13 -0700 (PDT)
Message-Id: <20100916.215313.180410528.davem@davemloft.net>
To: drosenberg@vsecurity.com
Cc: grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kyle@mcmartin.ca, jeffm@suse.com,
        security@kernel.org
Subject: Re: [PATCH v2] drivers/net/tulip/de4x5.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1284586998.6275.94.camel@dan>
References: <1284586998.6275.94.camel@dan>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>
Date: Wed, 15 Sep 2010 17:43:18 -0400

> Fixed formatting (tabs and line breaks).
> 
> This was previously reported as a security issue due to leakage of
> uninitialized stack memory.  Jeff Mahoney pointed out that this is
> incorrect since the copied data is from a union (rather than a struct).
> Therefore, this patch is only under consideration for the sake of
> correctness, and is not security relevant. 
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> Acked-by: Grant Grundler <grundler@parisc-linux.org>

You need to give something more descriptive than just the name of the
file you're editing in the Subject: line of this commit message.

Otherwise people scanning "shortlog" and similar output won't have
even a general idea of what kind of change your commit is making.

Please formally resubmit this with a proper commit header line.
