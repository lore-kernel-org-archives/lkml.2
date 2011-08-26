Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab1HZOJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 10:09:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33204 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1HZOJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 10:09:05 -0400
Date: Fri, 26 Aug 2011 16:09:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate
 subsys methods, take#2
Message-ID: <20110826140900.GF2632@htj.dyndns.org>
References: <1314312192-26885-1-git-send-email-tj@kernel.org>
 <4E5753D3.9080500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5753D3.9080500@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 26, 2011 at 04:05:39PM +0800, Li Zefan wrote:
> It's fine for me to route those patches through pm-freezer, since this
> work is initiated and needed for the work on freezer.

Awesome.  Paul, what do you think?  Rafael, if Paul agrees, can you
please take in this series?

Thanks.

-- 
tejun
