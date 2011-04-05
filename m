Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1DEMXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 08:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1DEMXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 08:23:43 -0400
Date: Tue, 5 Apr 2011 14:23:28 +0200
From: Karel Zak <kzak@redhat.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: victor.vde@gmail.com, util-linux@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eugene J. Markow" <ejmarkow@yahoo.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] libmount misparses mountinfo on Linux v2.6.39-rc1
Message-ID: <20110405122328.GA26986@nb.net.home>
References: <19860.58082.277944.875401@gargle.gargle.HOWL> <87d3l62z3k.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3l62z3k.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 01:16:23PM +0530, Aneesh Kumar K. V wrote:
> On Thu, 31 Mar 2011 22:24:01 +0200, victor.vde@gmail.com wrote:
> > /proc/self/mountinfo on Linux v2.6.39-rc1 includes the UUID of ext4
> > and ext3 mounts, for example:
> > 
> > 15 1 8:3 / / rw,noatime uuid:c645234d-9756-4d84-825e-6fe999252a34 - ext4 /dev/sda3 rw,user_xattr,acl,barrier=1,data=ordered
> > 
> > It seems the hyphens in the uuid confuse the parser
> > mnt_parse_mountinfo_line in tab_parse.c of libmount in util-linux.
> 
> shouldn't the parser look for " " followed by "-" followed by " " as the
> field seperator ? 
> 
> I am adding Miklos and Ram Pai to CC to check whether the kernel or the libmount 
> should be fixed ?

 The libmount (in util-linux git tree) should be fixed now. Thanks for
 the report! 

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
