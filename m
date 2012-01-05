Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab2AEQox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 11:44:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59472 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806Ab2AEQou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 11:44:50 -0500
Date: Thu, 5 Jan 2012 08:44:43 -0800
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Theodore Ts'o" <tytso@mit.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105164443.GB11934@google.com>
References: <m1boqietiv.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
 <20120105153233.GA11934@google.com>
 <m1ehvecf23.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehvecf23.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 05, 2012 at 08:03:16AM -0800, Eric W. Biederman wrote:
> Well the choices are really:
> a) On a block device hotunplug keep the device and have it simply report
>    everything as errors, to the filesystem.  Maybe with a hint to the
>    filesystem that something is wrong.
> b) Have a filesystem revoke method so that we don't have to keep the
>    unplugged block device structure around indefinitely.
> 
> It seems clear that we are neither doing (a) or (b) which results in
> periodic and spectacular failures when block devices are unplugged,
> because we try and access block devices that no longer exist.

We're definitely doing a).  If it's not working properly, it's a bug.

Thanks.

-- 
tejun
