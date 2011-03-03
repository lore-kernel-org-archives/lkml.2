Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab1CCGTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 01:19:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39415
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459Ab1CCGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 01:19:07 -0500
Date: Wed, 02 Mar 2011 22:19:44 -0800 (PST)
Message-Id: <20110302.221944.246546883.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AF_RXRPC: Handle receiving ACKALL packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110228132743.30463.33897.stgit@warthog.procyon.org.uk>
References: <20110228132743.30463.33897.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 28 Feb 2011 13:27:43 +0000

> The OpenAFS server is now sending ACKALL packets, so we need to handle them.
> Otherwise we report a protocol error and abort.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.
