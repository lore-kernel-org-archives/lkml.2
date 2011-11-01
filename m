Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1KAMR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:17:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36184 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1KAMRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:17:25 -0400
MIME-Version: 1.0
Date: Tue, 1 Nov 2011 17:47:24 +0530
Message-ID: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com>
Subject: Issue with core dump
From: trisha yad <trisha1march@gmail.com>
To: linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com, mhocko@suse.cz,
        rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I am running a multithreaded  application. So consider a global
variable x which is used by a, b and c thread.

In thread 'a' do abnormal operation(invalid memory access) and kernel
send signal kill to it. In the mean time Thread 'b' and Thread 'c'
got schedule and update
the variable x. when I got the core file, variable x  got updated, and
I am not  getting actual value that is present at time of crash of
thread a.
But In core file I got updated value of x. I want In core file exact
the same memory status as it at time of abnormal operation(invalid
memory access)

Is there any solution for such problem. ?

I want in core dump the same status  of memory as at time of abnormal
operation(invalid memory access).

Thanks
