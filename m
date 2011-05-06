Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1EFPEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:04:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43317 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1EFPEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=O6FQBXZCWcts/42QdRQJFUyvy53zeaG8Cq4jxeuoMwdgxIN+YbiBJBQ4AD9sKt0TO1
         2ZHjqYX+DdEBbBhrmwqFd2YNmyXZsPFAd4V6ONNfF18h+9/8L/eeRM/xOlmWV5wGrKIn
         qeqnS2qOTpsSYL8Lbwdnyn9g6C3yPIqFWwLa8=
MIME-Version: 1.0
Date: Fri, 6 May 2011 23:04:52 +0800
Message-ID: <BANLkTi=S_gSvnQimgqrMmq9eWJYDCDRVmA@mail.gmail.com>
Subject: [Question] how to detect mm leaker and kill?
From: Hillf Danton <dhillf@gmail.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

In the scenario that 2GB  physical RAM is available, and there is a
database application that eats 1.4GB RAM without leakage already
running, another leaker who leaks 4KB an hour is also running, could
the leaker be detected and killed in mm/oom_kill.c with default
configure when oom happens?

thanks
          Hillf
