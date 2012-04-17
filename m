Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab2DQCa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:30:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44420 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab2DQCa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:30:58 -0400
Date: Mon, 16 Apr 2012 19:30:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: zhangyanfei <zhangyanfei@cn.fujitsu.com>
Cc: avi@redhat.com, mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        joerg.roedel@amd.com, dzickus@redhat.com, paul.gortmaker@windriver.com,
        ludwig.nussel@suse.de, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 3/4] ksysfs: export VMCSINFO via sysfs
Message-ID: <20120417023053.GA19491@kroah.com>
References: <4F84E0DF.8040206@cn.fujitsu.com>
 <4F84E50E.2090008@cn.fujitsu.com>
 <20120412230058.GA23292@kroah.com>
 <4F8CCCEA.2090706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F8CCCEA.2090706@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:52:42AM +0800, zhangyanfei wrote:
> 于 2012年04月13日 07:00, Greg KH 写道:
> > On Wed, Apr 11, 2012 at 09:57:34AM +0800, zhangyanfei wrote:
> >> This patch creates sysfs file to export where VMCSINFO is allocated,
> >> as below:
> >>         $ cat /sys/kernel/vmcsinfo
> >>         1cb88a0 2000
> >> number on the left-hand side is the physical address of VMCSINFO,
> >> while the one on the right-hand side is the max size of VMCSINFO.
> > 
> > Ick, why do you have 2 values in one sysfs file, that's not nice, or
> > good.
> > 
> > What's wrong with 2 different files?
> > 
> 
> The reason why I put the 2 values in one sysfs file is that there is a similar
> file 'vmcoreinfo' in sysfs.
>         # cat /sys/kernel/vmcoreinfo 
>         1d75380 1000

Then that should be fixed as well, using two different file names now :(

thanks,

greg k-h
