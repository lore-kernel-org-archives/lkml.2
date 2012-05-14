Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab2ENVRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:17:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47047 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab2ENVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:17:07 -0400
Date: Mon, 14 May 2012 14:17:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        cl@linux-foundation.org, tony.luck@intel.com, bp@amd64.org,
        davem@davemloft.net, akpm@linux-foundation.org, ebiederm@xmission.com,
        sfr@canb.auug.org.au, luto@mit.edu, glommer@parallels.com,
        fernando@oss.ntt.co.jp, vapier@gentoo.org, eric.dumazet@gmail.com,
        dzickus@redhat.com, dhowells@redhat.com, cbouatmailru@gmail.com,
        fenghua.yu@intel.com, jkosina@suse.cz, ext-phil.2.carmody@nokia.com,
        dan.carpenter@oracle.com, len.brown@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, josh@joshtriplett.org, anton@samba.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] replace percpu_ops function with this_cpu_ops
Message-ID: <20120514211702.GK2366@google.com>
References: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:00:12PM +0800, Alex Shi wrote:
> I am sorry for mess commit log previous patchset.
> 
> As Andrew Morton's request, I combind and clean up the patchset.
> 
> According to Ingo's complain. I use the same and short 
> 'this_cpu_ops' functions in x86 part code.
> 
> Thanks for all comments!
> 
> [PATCH 1/3] net: replace percpu_xxx funcs with this_cpu_xxx or
> [PATCH 2/3] x86: replace percpu_xxx funcs with this_cpu_xxx
> [PATCH 3/3] percpu: remove percpu_xxx() functions

Applied to percpu/for-3.5.  Thanks.

-- 
tejun
