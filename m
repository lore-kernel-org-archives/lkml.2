Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab2DDS4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 14:56:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38741 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2DDS4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 14:56:12 -0400
Date: Wed, 4 Apr 2012 11:56:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, ctalbott@google.com, rni@google.com,
        andrea@betterlinux.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org,
        linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [Lsf] [RFC] writeback and cgroup
Message-ID: <20120404185605.GC29686@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <CAH2r5mtwQa0Uu=_Yd2JywVJXA=OMGV43X_OUfziC-yeVy9BGtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtwQa0Uu=_Yd2JywVJXA=OMGV43X_OUfziC-yeVy9BGtQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 10:36:04AM -0500, Steve French wrote:
> > How do you take care of thorottling IO to NFS case in this model? Current
> > throttling logic is tied to block device and in case of NFS, there is no
> > block device.
> 
> Similarly smb2 gets congestion info (number of "credits") returned from
> the server on every response - but not sure why congestion
> control is tied to the block device when this would create
> problems for network file systems

I hope the previous replies answered this.  It's about writeback
getting pressure from bdi and isn't restricted to block devices.

Thanks.

-- 
tejun
