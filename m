Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab0KNAFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 19:05:33 -0500
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:44740 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754395Ab0KNAFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 19:05:31 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-13.arcor-online.net C2407212EE0
Message-Id: <E1PHQ64-0001M1-OD@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH] oom: allow a non-CAP_SYS_RESOURCE proces to oom_score_adj  down
To: Mandeep Singh Baines <msb@google.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org, gspencer@chromium.org,
        piman@chromium.org, wad@chromium.org, olofj@chromium.org,
        Bodo Eggert <7eggert@web.de>
Reply-To: 7eggert@gmx.de
Date: Sun, 14 Nov 2010 01:05:28 +0100
References: <fNx73-1cI-1@gated-at.bofh.it> <fNzVf-5UY-3@gated-at.bofh.it> <fNKdY-6FU-11@gated-at.bofh.it> <fNMps-1S1-21@gated-at.bofh.it> <fNNOx-4qf-1@gated-at.bofh.it> <fNOAW-5Oi-35@gated-at.bofh.it> <fNPdF-6Hu-33@gated-at.bofh.it> <fOctz-4o0-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines <msb@google.com> wrote:

> We'd like to be able to oom_score_adj a process up/down as its
> enters/leaves the foreground. Currently, it is not possible to oom_adj
> down without CAP_SYS_RESOURCE. This patch allows a task to decrease
> its oom_score_adj back to the value that a CAP_SYS_RESOURCE thread set
> it or its inherited value at fork. Assuming the thread that has forked
> it has oom_score_adj of 0, each tab

process

> could decrease it back from 0 upon 
> activation unless a CAP_SYS_RESOURCE thread elevated it to something
> higher.



