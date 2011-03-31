Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1CaXDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:03:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab1CaXDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:03:31 -0400
Date: Thu, 31 Mar 2011 18:56:18 -0400
From: Josef Bacik <josef@redhat.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com,
        josef@redhat.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        chris.mason@oracle.com, jlbec@evilplan.org, tm@tao.ma
Subject: Re: [PATCH 1/3] VFS/ioctl: Add punching-hole support to ioctl().
Message-ID: <20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com> <4D94EEC3.2030206@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D94EEC3.2030206@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 02:14:43PM -0700, Sunil Mushran wrote:
> Frankly I see no point extending the ioctl interface when we have
> a syscall interface.
>

I'd even go so far as to say we could probably axe the xfs and ocfs2 ioctls
since we have the fallocate interface :).  Thanks,

Josef
