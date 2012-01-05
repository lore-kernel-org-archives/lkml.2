Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2AEUzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:55:36 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55892 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932805Ab2AEUze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:55:34 -0500
Date: Thu, 5 Jan 2012 12:55:28 -0800
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105205528.GB2934@google.com>
References: <m1ehvecf23.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051133490.1434-100000@iolanthe.rowland.org>
 <20120105182752.GC26382@thunk.org>
 <20120105183602.GE18486@google.com>
 <m1d3axc23k.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d3axc23k.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 12:43:11PM -0800, Eric W. Biederman wrote:
> That does require a notification from the block device going away
> to the filesystem.  Tejun is there an existing mechanism that we
> can plug into or do we need to implement something new?

Of course, udev.

Thanks.

-- 
tejun
