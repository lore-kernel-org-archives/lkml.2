Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab2B2QWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 11:22:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40811 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662Ab2B2QWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 11:22:34 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jhautbois@gmail.com designates 10.180.92.73 as permitted sender) smtp.mail=jhautbois@gmail.com; dkim=pass header.i=jhautbois@gmail.com
MIME-Version: 1.0
From: Jean-Michel Hautbois <jhautbois@gmail.com>
Date: Wed, 29 Feb 2012 17:22:13 +0100
Message-ID: <CAL8zT=j3aeS5xhUOpGe4hJ05Ls0TCtf354hG=eHYvGT-fjmrjg@mail.gmail.com>
Subject: Combining perf timechart with perf sched map
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

First things first : I didn't know how to ask my question, so pardon
me if the subject of this mail is not a good one.

I am trying to use the amazing perf tool using 'perf sched map' and I
must say it is quite difficult to follow when there is lots of CPUs
(24 in my case) and lots of process (more than 100) to analyse.
I wondered if there is a solution like combining the timechart tool
with this one in order to produce a graphical colored output which
would help noticing workload balancing issues.
Maybe is it already possible ?
If not, maybe a tool like kernelshark would be a good tool for that,
but I have to say I am not fluent in python so I don't really know how
I can help with this.

Thanks in advance for your help,
Regards,
JM
