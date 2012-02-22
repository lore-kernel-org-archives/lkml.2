Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab2BVB7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 20:59:38 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:62914 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2BVB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 20:59:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of cyfmxc@gmail.com designates 10.229.135.10 as permitted sender) smtp.mail=cyfmxc@gmail.com; dkim=pass header.i=cyfmxc@gmail.com
MIME-Version: 1.0
X-Google-Sender-Delegation: tabloid.adroit@gmail.com
Date: Tue, 21 Feb 2012 20:59:36 -0500
X-Google-Sender-Auth: RmLwHPEfTGKsmgS83mvY5eU_vBs
Message-ID: <CAJh9x3qSF99aEAZcAHzjSi7Xqt2D8HrDAjeTNVcO7XQUsukLkA@mail.gmail.com>
Subject: perf record: can I specify multiple events and use different
 sample-after value
From: Yuanfang Chen <cyfmxc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying use perf tool from the linux kernel package to measure
several raw PMU events. In the manpage of perf-record there is an "-l"
option (Scale counter values), which is useful for my case because I
want to know the total counter value, not just sample count. However
it seems the -l is not recognized, is this expected? How can I get a
total count?

Another question is that how can I specify multiple events and use
different sample-after value for each of them? like perf record -c
10000,2000000,2000000 -e r2d4,r03c,r0c0

thank you
