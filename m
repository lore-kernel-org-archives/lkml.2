Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1HXLn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 07:43:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41959 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1HXLny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 07:43:54 -0400
MIME-Version: 1.0
Date: Wed, 24 Aug 2011 19:43:53 +0800
Message-ID: <CACPU8qKHq8CLqprMtT=3t7H-xCyY+gw0JBxFtt4mJVKF+FESBw@mail.gmail.com>
Subject: 
From: gengjia ding <gengjia.ding@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

trying to modify source file net/sched/sch_generic.c in Linux Kernel
2.6.37.6, add code(+):
+ #include <linux/tcp.h>
+ #include <net/tcp.h>
static int pfifo_fast_enqueue(struct sk_buff *skb, struct Qdisc* qdisc){
    + struct tcphdr *th = tcp_hdr(skb);

}
I just want to get the transport header of the socket buffer.
After recompile the kernel and reboot, the network is  unable to startup.

But when i
Where did it make the mistake?

Thanks,
Gavin Ding
