Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2HFOhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:37:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50878 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab2HFOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:37:19 -0400
MIME-Version: 1.0
Date: Mon, 6 Aug 2012 22:37:17 +0800
Message-ID: <CANQmPXg_easObFwAdBHYYUA0q-2z3n0HZA8N8qmCu9qxFaS3BA@mail.gmail.com>
Subject: [PATCH]RIFS scheduler ready for 3.5.x kernel
From: Chen <hi3766691@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mou Chen <hi3766691@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone.

RIFS offical patch for 3.5.x kernel:
http://rifs-scheduler.googlecode.com/files/rifs-kernel3.5.x
The tweaks of the scheduler can be found at '/proc/sys/sched_rifs'.

RIFS-ES scheduler has been rewritten to solve some strange behavior
e.g. strange CPU load(Reported by ID:KernelOfTruth on Phoronix).The
part I have rewritten is about the tick accounting. Also the scheduler
is a strict scheduler(No any special treats, unlike the previous
RIFS-ES scheduler).
RIFS-ES patch for 3.5 kernel:
http://rifs-scheduler.googlecode.com/files/rifs-es-kernel3.5.x

                       Chen
