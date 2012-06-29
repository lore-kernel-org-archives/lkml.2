Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab2F2Xu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 19:50:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39088 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2F2XuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 19:50:24 -0400
Date: Fri, 29 Jun 2012 16:50:23 -0700 (PDT)
Message-Id: <20120629.165023.1605284574408858612.davem@davemloft.net>
To: vincent.sanders@collabora.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: AF_BUS socket address family
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120629234230.GA11480@kyllikki.org>
References: <20120629231236.GA28593@mail.collabora.co.uk>
	<20120629.161821.948325645333976311.davem@davemloft.net>
	<20120629234230.GA11480@kyllikki.org>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Sanders <vincent.sanders@collabora.co.uk>
Date: Sat, 30 Jun 2012 00:42:30 +0100

> Basically you are indicating you would be completely opposed to any
> mechanism involving D-Bus IPC and the kernel? 

I would not oppose existing mechanisms, which I do not believe is
impossible to use in your scenerio.

What you really don't get is that packet drops and event losses are
absolutely fundamental.

As long as receivers lack infinite receive queue this will always be
the case.

Multicast operates in non-reliable transports only so that one stuck
or malfunctioning receiver doesn't screw things over for everyone nor
unduly brudon the sender.

