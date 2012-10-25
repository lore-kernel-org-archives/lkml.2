Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2JYXhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:37:39 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37879 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2JYXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:37:38 -0400
MIME-Version: 1.0
Date: Fri, 26 Oct 2012 00:37:36 +0100
Message-ID: <CAKw44fY_f69qGXHbcyXvr4i=or4FpB7TDQVijLkN7tv5iU-zrQ@mail.gmail.com>
Subject: Power regression found on 3.6-rc1+
From: Micael <kam1kaz3@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a laptop running Arch Linux and found that upgrading from 3.5.6
to 3.6.2 had a huge impact on my battery life. Power consumption went
from ~10W to ~20W.
I initially thought it was a i915 driver problem since the CPU temps
went up and so I opened this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=49031

However, as you can see if you read the bug's comments, after
bisecting this I found the culprit to be commit
71a83bd727cc31c5fe960c3758cb396267ff710e:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=71a83bd727cc31c5fe960c3758cb396267ff710e

--
Micael Dias
