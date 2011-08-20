Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1HTULB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 16:11:01 -0400
Received: from lucidpixels.com ([72.73.18.11]:39741 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1HTULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 16:11:00 -0400
Date: Sat, 20 Aug 2011 16:10:59 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: 3.0.1 kernel: INFO: rcu_sched_state detected stall on CPU 1 (t=60000
 jiffies)
Message-ID: <alpine.DEB.2.02.1108201610180.14176@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Never seen this error before, FYI (doing lots of rsyncs):

[  993.781001] INFO: rcu_sched_state detected stall on CPU 1 (t=60000 jiffies)
[ 1173.812001] INFO: rcu_sched_state detected stall on CPU 1 (t=240031 jiffies)
[ 1353.843001] INFO: rcu_sched_state detected stall on CPU 1 (t=420062 jiffies)
[ 1533.874001] INFO: rcu_sched_state detected stall on CPU 1 (t=600093 jiffies)

Justin.


