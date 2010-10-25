Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360Ab0JYTPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:15:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40789
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab0JYTPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:15:01 -0400
Date: Mon, 25 Oct 2010 12:15:24 -0700 (PDT)
Message-Id: <20101025.121524.183040367.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        swise@opengridcomputing.com
Subject: Re: [PATCH net-2.6] cxgb3: fix device opening error path
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101025173502.27055.847.stgit@speedy5.asicdesigners.com>
References: <20101025173502.27055.847.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 25 Oct 2010 10:35:02 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Only negative return from bind_qsets() should be considered an error and
> propagated.
> It fixes an issue reported by IBM on P Series platform.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

Applied.
