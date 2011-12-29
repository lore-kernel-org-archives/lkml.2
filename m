Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1L2ITT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 03:19:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab1L2ITQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 03:19:16 -0500
Date: Thu, 29 Dec 2011 08:19:10 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com
Subject: Re: Bug in BLKBSZSET/GET ioctl ?
Message-ID: <20111229081910.GA26708@amd.home.annexia.org>
References: <4EFBE3D1.5030608@cn.fujitsu.com>
 <4EFBE4EB.3040001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EFBE4EB.3040001@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 11:56:27AM +0800, Wanlong Gao wrote:
> On 12/29/2011 11:51 AM, Wanlong Gao wrote:
> 
> > Hi all:
> > 
> > This is first reported to *libguestfs*: https://bugzilla.redhat.com/show_bug.cgi?id=624335
> 
> 
> The blockdev-get/setbsz in *libguestfs* is just a wraper of util-linux's *blockdev --get/setbsz*.

Agreed.

I don't think libguestfs is anything to do with it, since those
commands simply translate to running
/sbin/blockdev --{get,set}bsz /dev/sdX:

http://git.annexia.org/?p=libguestfs.git;a=blob;f=daemon/blockdev.c;h=d056abef1739de7b9e9aab118c138bae403e11e5;hb=HEAD#l106

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://et.redhat.com/~rjones/virt-top
