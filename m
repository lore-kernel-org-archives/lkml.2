Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab0EYWjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:39:23 -0400
Received: from xenotime.net ([72.52.115.56]:37619 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750800Ab0EYWjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:39:21 -0400
Date: Tue, 25 May 2010 15:39:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       "David S. Miller" <davem@davemloft.net>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 1/1] driver core: add devname module aliases to allow
 module on-demand auto-loading
Message-Id: <20100525153912.0ba10435.rdunlap@xenotime.net>
In-Reply-To: <1274825798-29613-1-git-send-email-gregkh@suse.de>
References: <20100525221546.GA29511@kroah.com>
	<1274825798-29613-1-git-send-email-gregkh@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 15:16:38 -0700 Greg Kroah-Hartman wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> This adds:
>   alias: devname:<name>
> to some common kernel modules, which will allow the on-demand loading
> of the kernel module when the device node is accessed.
> 
> Ideally all these modules would be compiled-in, but distros seems too
> much in love with their modularization that we need to cover the common
> cases with this new facility. It will allow us to remove a bunch of pretty
> useless init scripts and modprobes from init scripts.

[snip]


I have no objection to this patch or to it being merged.

I just note that this patch was posted to lkml on 2010-May-20.

If it causes any problems, it can easily be reverted.

I think that some (other, non-gregkh and non-davem) maintainers take far too long
to merge some patches.  Maybe it's just a merge window thing.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
