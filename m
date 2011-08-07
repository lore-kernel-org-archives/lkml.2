Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab1HGCDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 22:03:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64679 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab1HGCDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 22:03:54 -0400
MIME-Version: 1.0
Date: Sat, 6 Aug 2011 19:03:53 -0700
Message-ID: <CA+yNG29pbNxiES1kR=sKr3Sn3g8rgz5p17dZq7MBHz1F9hnkCA@mail.gmail.com>
Subject: preempt_disable and softirq
From: Venkat Subbiah <v.subbiah@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does disabling preemption by calling preempt_disable() cause softirqs
on the local cpu to be disabled too?

I believe drivers napi polling functions is being called when the
current cpu is holding on to a read lock of tasklist_lock. read_lock()
itself disables preemption.

An easy way to check in the napi polling functions that the current
cpu is not holding on to tasklist_lock? Of course this is mute if
softirqs itself cannot execute when premption is disabled.

PS: I am not subscribed to the groups. Please CC me on your answer.

Thanks,
Venkat
