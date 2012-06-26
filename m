Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2FZXAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 19:00:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56792 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2FZXAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 19:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
Date: Wed, 27 Jun 2012 08:00:17 +0900
Message-ID: <CALLJCT10NT_s4fbkiFb8k7LQMQW=YH14YgOD6hCRLxVPOPoncg@mail.gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
From: Masanari Iida <standby24x7@gmail.com>
To: shyju pv <shyju.pv@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>, Sanil kumar <sanil.kumar@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Shyju,
I have also encountered this symptom since 3.5-rc1.
Still exist on 3.5-rc4.  The last known working is 3.4.

In my case, either "shutdown or reboot" or "service cgroup stop"
reproduce this symptom.

I have opened https://bugzilla.kernel.org/show_bug.cgi?id=43771

Masanari
