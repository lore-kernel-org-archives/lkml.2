Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab2DAI1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 04:27:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41328 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2DAI1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 04:27:32 -0400
MIME-Version: 1.0
Date: Sun, 1 Apr 2012 16:27:32 +0800
Message-ID: <CAFgQCTtg1U7V_WbJ2uZG9unM5qV6sPfoCMbrMVdXrebwue6wzg@mail.gmail.com>
Subject: net-sched: When TX over-limit happens on netdev, what does kernel do?
From: Liu ping fan <kernelfans@gmail.com>
To: linux-net@vger.kernel.org
Cc: Jamal Hadi Salim <hadi@cyberus.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could anybody tell me when TX over-limit happens on netdev, what does kernel do?
Is skb buffered in Qdisc->q and the sending process keeps running?
Or we block the sending process and make it scheduled?

Found some code in net/sched/sch_cbq.c
cbq_dequeue(struct Qdisc *sch) --> qdisc_watchdog_schedule(),  so I
guess the skb is buffered in Qdisc, but what about sending process?


Thanks and regards,
pingfan
