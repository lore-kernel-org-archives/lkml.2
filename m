Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2F0S3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:29:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42623 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab2F0S3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:29:08 -0400
Date: Wed, 27 Jun 2012 11:29:03 -0700
From: "tj@kernel.org" <tj@kernel.org>
To: shyju pv <shyju.pv@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup
 cgroup]
Message-ID: <20120627182903.GP15811@google.com>
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 07:08:07PM +0000, shyju pv wrote:
> Hi,
> Observed a crash on 3.5-rc3 with cgroup tests from LTP(Stable April,2012 release)on Dell Inspiron 1526[Intel(R) Core2Duo T7250, MEM 4GB] and also on another x86 quad core target(4GB RAM).
> LTP test case: cgroup_regression_test.sh(test 4,7 and 9 crashes randomly when the test cases are executed in order)
> Shyju
> 
> [  532.805905] BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgrou

Hmm... fa980ca87d "cgroup: superblock can't be released with active
dentries" is supposed to have fixed that.  Looking into it.

Thanks.

-- 
tejun
