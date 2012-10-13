Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2JMVrl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 17:47:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59836 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2JMVrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 17:47:40 -0400
Date: Sat, 13 Oct 2012 17:47:36 -0400 (EDT)
Message-Id: <20121013.174736.772385853004175046.davem@davemloft.net>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH 1/2] UAPI: Unexport part of linux/ppp-comp.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20121013090809.28574.46706.stgit@warthog.procyon.org.uk>
References: <20121013090809.28574.46706.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Sat, 13 Oct 2012 10:08:10 +0100

> Unexport part of linux/ppp-comp.h as userspace can't make use of that bit.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
