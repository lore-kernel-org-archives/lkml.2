Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1JRPT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:19:26 -0400
Received: from mail-bw0-f66.google.com ([209.85.214.66]:64003 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1JRPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:19:25 -0400
MIME-Version: 1.0
Date: Tue, 18 Oct 2011 20:49:22 +0530
Message-ID: <CAKj1SsO-U=cV9RQdHLv3sD_UYGJ+Vw3EqM2TNcPWCkPkWW6Jqw@mail.gmail.com>
Subject: 
From: raviraj joshi <raviraj.j1991@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are making a kernel level packet capture module as a part of our BE project .
We are finding it difficult to understand kenel networking code.
We studied structures and functions like sk_buff, netif_rx(),dev_alloc_skb.
How ever we were not able to trace the actual path a simple packet follows.
Moreover we tried to count the no of times netif_rx function was
called it was much much lower than amount of packets actually being
received.
Can anyone please let us know the reason for this and how to approach
the problem of writing a kernel level packet capture module.

regards,
Raviraj Joshi
PICT,Pune.
