Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab2GHGfn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 02:35:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42081 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2GHGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 02:35:41 -0400
Date: Sat, 7 Jul 2012 23:35:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        viro@zeniv.linux.org.uk, levinsasha928@gmail.com
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
Message-ID: <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4FEEA5CB.8070809@huawei.com>
 <20120703170317.GB555@google.com>
 <20120703225218.GF555@google.com>
 <4FF3E063.5010604@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3E063.5010604@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Jul 04, 2012 at 02:19:15PM +0800, Li Zefan wrote:
> > I think we're horridly broken for
> > root cgroup tho - and it has been broken for very long time.  I think
> > it's mostly hidden because most (all?) controllers short-circuit root
> > cgroup.  Eh, well....
> > 
> 
> Could you elaborate a bit on what's broken for root cgroup?

If someone holds css ref of a root cgroup, AFAICS nothing is
preventing the cgroup hierarchy from being unmounted and root cgroup
destroyed.

Thanks.

-- 
tejun
