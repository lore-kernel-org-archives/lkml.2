Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab2ENSBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:01:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45686 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab2ENSBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:01:35 -0400
Date: Mon, 14 May 2012 11:01:28 -0700
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
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
Message-ID: <20120514180128.GC2366@google.com>
References: <1336723215-16660-1-git-send-email-alex.shi@intel.com>
 <20120514173421.GB2366@google.com>
 <4FB142D1.7080403@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB142D1.7080403@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 10:37:21AM -0700, H. Peter Anvin wrote:
> I would be happier if we kept the patchset together.
> 
> So I would greatly prefer if you'd take the whole patchset with my:
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Yeap, that works too.  David, can I route the network part too with
your ack?

Thanks.

-- 
tejun
