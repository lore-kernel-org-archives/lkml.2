Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1B1VVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:21:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43790
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755370Ab1B1VVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:21:11 -0500
Date: Mon, 28 Feb 2011 13:21:48 -0800 (PST)
Message-Id: <20110228.132148.116384901.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, fubar@us.ibm.com, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: use the correct size for _simple_hash()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298885668-3917-1-git-send-email-amwang@redhat.com>
References: <1298885668-3917-1-git-send-email-amwang@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>
Date: Mon, 28 Feb 2011 17:34:28 +0800

> Clearly it should be the size of ->ip_dst here.
> Although this is harmless, but it still reads odd.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Applied to net-next-2.6, thanks.
