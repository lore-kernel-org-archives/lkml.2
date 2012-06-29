Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2F2XSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:18:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38941 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2F2XSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:18:24 -0400
Date: Fri, 29 Jun 2012 16:18:21 -0700 (PDT)
Message-Id: <20120629.161821.948325645333976311.davem@davemloft.net>
To: vincent.sanders@collabora.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120629231236.GA28593@mail.collabora.co.uk>
References: <1340988354-26981-1-git-send-email-vincent.sanders@collabora.co.uk>
	<20120629.153656.1141845894730637434.davem@davemloft.net>
	<20120629231236.GA28593@mail.collabora.co.uk>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Sanders <vincent.sanders@collabora.co.uk>
Date: Sat, 30 Jun 2012 00:12:37 +0100

> I had hoped you would have at least read the opening list where I
> outlined the underlying features which explain why none of the
> existing IPC match the requirements.

I had hoped that you had read the part we told you last time where
we explained why multicast and "reliable delivery" are fundamentally
incompatible attributes.

We are not creating a full address family in the kernel which exists
for one, and only one, specific and difficult user.
