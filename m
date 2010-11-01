Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0KAVJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:09:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39656
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab0KAVJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:09:49 -0400
Date: Mon, 01 Nov 2010 14:10:13 -0700 (PDT)
Message-Id: <20101101.141013.35028696.davem@davemloft.net>
To: divy@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dm@chelsio.com,
        leedom@chelsio.com, swise@opengridcomputing.com
Subject: Re: [PATCH net-2.6 1/3] cxgb3: remove call to stop TX queues at
 load time.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101101205940.27716.24553.stgit@speedy5.asicdesigners.com>
References: <20101101205940.27716.24553.stgit@speedy5.asicdesigners.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>
Date: Mon, 01 Nov 2010 13:59:41 -0700

> From: Divy Le Ray <divy@chelsio.com>
> 
> Remove racy queue stopping after device registration.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

Applied.
