Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab2ECJRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:17:22 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44514 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756185Ab2ECJRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:17:20 -0400
MIME-Version: 1.0
From: Philipp Riemer <ruderphilipp@gmail.com>
Date: Thu, 3 May 2012 11:16:59 +0200
Message-ID: <CAFU-uVsxa8tY+ZUJJStBLMXTtTrobeVC7z-dpwHMq0M=9vfbEQ@mail.gmail.com>
Subject: proposal of a new mailmap file for the linux kernel git repository
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear members of the LKML,
one of the advantages of distributed version systems such as the here
used Git is also the weakness of those: everyone has its own copy of
the repository and there is no authority controlling it (in general).
As a result every developer can use whatever name and email address he
or she wants to use. This leads to the fact that many people have
typos in there names or use ".local" or ".(none)" email addresses.
Hence, Git supports .mailmap files to overcome this and correct known
mistakes.

The .mailmap file of the Linux Kernel consists of around 100 entries
at the moment. Due to my work for my thesis I am currently skim
through all names and email addresses and add ambiguous ones to the
mailmap file as well. This lead to a size of around 2000 lines.

Because this is my first contribution to the Linux Kernel and since
the size of the file is huge compared to most other patches, I want to
ask if I still should post the (patch) file here or if the link to my
GitHub clone (<https://github.com/ruderphilipp/linux>, branch
"mailmap-changes") is enough?
Or should I send the file directly to one maintainer? For the latter,
who would be the best person in this case? Paul Mundt because he
pushed the last changes of this file to the official repository? Wang
Chen as the maintainer of the Linux Kernel Patch Statistic? Or someone
else?

It is not the final version, yet, since I still have around 2.5% (500
of originally around 20000 entries) to analyze. But I would say that
this file is as good as done.

With regards,
Philipp Riemer

PS: I would appreciate if everyone searches for his or her own name in
the list under <https://github.com/ruderphilipp/linux/blob/mailmap-changes/.mailmap>
and corrects it if necessary.
