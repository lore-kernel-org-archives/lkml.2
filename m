Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2ADSUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:20:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36819 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2ADSUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:20:46 -0500
Date: Wed, 4 Jan 2012 10:20:41 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Sysfs attributes racing with unregistration
Message-ID: <20120104182041.GO31746@google.com>
References: <20120104171842.GN31746@google.com>
 <Pine.LNX.4.44L0.1201041300130.1505-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201041300130.1505-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 04, 2012 at 01:13:41PM -0500, Alan Stern wrote:
> Now, looking through the code, I wonder why sysfs_{get,put}_active() 
> and sysfs_deactivate() don't use a real rwsem.  Why go to all the 
> effort of imitating one?  Is it just to save space?

Hmmm... maybe there was something which prevented that or maybe I was
just being stupid.  I don't really remember.  Space is a fairly
important consideration too.  Depending on configuration, there can be
a LOT of sysfs_dirents and memory consumption from sysfs has been a
real problem.

Thanks.

-- 
tejun
