Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514Ab1CaXpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:45:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41131 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1CaXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:45:07 -0400
Date: Thu, 31 Mar 2011 16:44:55 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Josef Bacik <josef@redhat.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
        Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, chris.mason@oracle.com, tm@tao.ma
Subject: Re: [PATCH 1/3] VFS/ioctl: Add punching-hole support to ioctl().
Message-ID: <20110331234454.GB18808@noexit>
Mail-Followup-To: Josef Bacik <josef@redhat.com>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, chris.mason@oracle.com, tm@tao.ma
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
 <4D94EEC3.2030206@oracle.com>
 <20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 06:56:18PM -0400, Josef Bacik wrote:
> On Thu, Mar 31, 2011 at 02:14:43PM -0700, Sunil Mushran wrote:
> > Frankly I see no point extending the ioctl interface when we have
> > a syscall interface.
> >
> 
> I'd even go so far as to say we could probably axe the xfs and ocfs2 ioctls
> since we have the fallocate interface :).  Thanks,

	These ioctls are in long use.  Granted, it is for the small
subset of users that know xfs and ocfs2 can do this, but still.
<venkman>Breaking userspace is *bad*.</venkman>
	More interesting would be to bring the ioctls up to generic code
and have them backended by fallocate.  I'm not sure they map without
looking deeper, but it's at least an idea.

Joel

-- 

 print STDOUT q
 Just another Perl hacker,
 unless $spring
	- Larry Wall

			http://www.jlbec.org/
			jlbec@evilplan.org
