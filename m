Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1KQTDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:03:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40567 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab1KQTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:03:39 -0500
MIME-Version: 1.0
Date: Thu, 17 Nov 2011 20:03:37 +0100
Message-ID: <CACLQ8Mu_QvTi0ioLzLAmDHOOtRRc4RvSFFae3XPKdoL_e05VPQ@mail.gmail.com>
Subject: kernel 3.1 lots of cpu stalls and lockups
From: Mariusz Libera <mariusz.libera@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since updating from kernel 3.0 to 3.1 I'm experiencing lockups.
They happen quite randomly, sometimes after 1 day of running,
other times after few hours or just few minutes after booting.
I don't have an idea what may be causing them, but in dmesg I see lots of

INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by
0, t=18002 jiffies)

and backtraces.

Please have a look at following ArchLinux bug report with logs and comments from
other affected people.

https://bugs.archlinux.org/task/26847

Mariusz Libera
