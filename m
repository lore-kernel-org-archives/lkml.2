Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3ACNMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:12:49 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:59308 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab3ACNMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:12:45 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 3 Jan 2013 14:12:44 +0100
Message-ID: <CA+icZUVEvzyrPsQG1QWLnHxhtaewaWTOVzBpTnLqjKuHMjjFHg@mail.gmail.com>
Subject: Re: [PATCH net-next] softirq: reduce latencies
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

your patch from [2] applies cleanly on top of Linux v3.8-rc2.
I would like to test it.
In [1] you were talking about benchmarks you did.
Can you describe them or provide a testcase (script etc.)?
You made only network testing?
Thanks in advance.

Regards,
- Sedat -

[1] http://marc.info/?l=linux-kernel&m=135721614718434&w=2
[2] https://patchwork.kernel.org/patch/1927531/
