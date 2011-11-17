Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab1KQHM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 02:12:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35980 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1KQHM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 02:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <1321372757-1581-5-git-send-email-glommer@parallels.com>
References: <1321372757-1581-1-git-send-email-glommer@parallels.com>
	<1321372757-1581-5-git-send-email-glommer@parallels.com>
Date: Thu, 17 Nov 2011 12:42:25 +0530
Message-ID: <CAKTCnz=FxTbNcV4HmZtDqCf09kq3Aw20QBK0-KKy-n1Obef_Bg@mail.gmail.com>
Subject: Re: [PATCH 4/4] provide a version of cpuacct statistics inside cpu cgroup
From: Balbir Singh <bsingharora@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 9:29 PM, Glauber Costa <glommer@parallels.com> wrote:
> For users interested in using the information currently displayed
> at cpuacct.stat, we provide it inside the cpu cgroup.

I presume I need to mount cpu to see these stats and cpu implies
control today - no? Can I only monitor statistics without implementing
control? Please see the other thread as well.

Balbir
