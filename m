Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab0CWBdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:33:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59925
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756685Ab0CWBdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:33:08 -0400
Date: Mon, 22 Mar 2010 18:33:31 -0700 (PDT)
Message-Id: <20100322.183331.45148439.davem@davemloft.net>
To: error27@gmail.com
Cc: netdev@vger.kernel.org, shemminger@vyatta.com, kaber@trash.net,
       jpirko@redhat.com, adobriyan@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] ewrk3: range checking problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100322120728.GD21571@bicker>
References: <20100322120728.GD21571@bicker>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>
Date: Mon, 22 Mar 2010 15:07:28 +0300

> The range checking here is wrong.  It should be HASH_TABLE_LEN which 
> is 512.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied.
