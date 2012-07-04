Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2GDOx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:53:56 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:52642 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2GDOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:53:51 -0400
Date: Wed, 4 Jul 2012 07:53:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, ebiederm@xmission.com,
        luto@mit.edu, Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH v4 3/3] Documentation: Add ABI entry for vmcs sysfs
 interface
Message-ID: <20120704145345.GG23020@kroah.com>
References: <4FF413D2.4030006@cn.fujitsu.com>
 <4FF415A4.8040405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF415A4.8040405@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 06:06:28PM +0800, Yanfei Zhang wrote:
> Signed-off-by: zhangyanfei <zhangyanfei@cn.fujitsu.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu |   21 ++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 5dab364..6efbd6c 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -9,6 +9,27 @@ Description:
>  
>  		/sys/devices/system/cpu/cpu#/
>  
> +What:		/sys/devices/system/cpu/vmcs_id

Wait, aren't these a per-cpu value?  You have them as a "global" value
for all cpus, is that really the case?  Shouldn't they be under
/sys/devices/system/cpu/cpu#/ instead?

thanks,

greg k-h
