Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0CQGOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:14:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43296
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216Ab0CQGOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:14:14 -0400
Date: Tue, 16 Mar 2010 23:14:34 -0700 (PDT)
Message-Id: <20100316.231434.177653499.davem@davemloft.net>
To: amwang@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Patch] netpoll: allow spaces in its parameter
From: David Miller <davem@davemloft.net>
In-Reply-To: <4BA071BD.5040900@redhat.com>
References: <4BA07022.1040702@redhat.com>
	<20100316.225950.222623826.davem@davemloft.net>
	<4BA071BD.5040900@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Wed, 17 Mar 2010 14:07:57 +0800

> No, but silently accepting it as 0 is not correct, why don't
> reject it if it is not allowed?

You have to be careful even with that.  For example, if two
netconsoles are specified, seeing the space shouldn't
kill the first netconsole specification we parsed.

A warning perhaps, but outright rejection of all specifications is
really bad behavior.
