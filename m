Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1DAHOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 03:14:54 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:49960 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754811Ab1DAHOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 03:14:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkcGAOt3lU15LK5JgWdsb2JhbACER5QWjH0VAQEWJiWvQ5B6DYEbg0x3BJQk
Date: Fri, 1 Apr 2011 18:14:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: namei.unix@gmail.com
Cc: Alex Elder <aelder@sgi.com>, Liu Yuan <tailai.ly@taobao.com>,
        "supporter:XFS FILESYSTEM" <xfs-masters@oss.sgi.com>,
        "open list:XFS FILESYSTEM" <xfs@oss.sgi.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Remove unused =?utf-8?Q?v?=
	=?utf-8?B?YXJpYWJsZSDigJhiZGnigJk=?=
Message-ID: <20110401071449.GC6957@dastard>
References: <1301632050-12674-1-git-send-email-namei.unix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301632050-12674-1-git-send-email-namei.unix@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 12:27:30PM +0800, namei.unix@gmail.com wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
> 
> When building kernel, I met a warning:
> ...
> fs/xfs/linux-2.6/xfs_buf.c:660: warning: unused variable ‘bdi’
> ...

There is alreayd a patch in the XFS tree to fix this:

http://oss.sgi.com/archives/xfs/2011-03/msg00397.html

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
