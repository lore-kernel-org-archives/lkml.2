Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab1KXVrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:47:13 -0500
Received: from science.horizon.com ([71.41.210.146]:23828 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753837Ab1KXVrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:47:11 -0500
Date: 24 Nov 2011 16:47:10 -0500
Message-ID: <20111124214710.13413.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, viro@ZenIV.linux.org.uk
Subject: Re: 3.1-rc10 oops in nameidata_to_filp
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20111124173829.GL2203@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the pointer.  I'll write some debug code.

> Said that, I'm not buying the theory of open assigning to ->f_mapping and
> screwing it up; all such assignments end up with ->i_mapping of *some*
> inode, as far as I can see from cursory grep over the tree.  Just in case:
> do you have CONFIG_FS_POSIX_ACL set?

No, I always turn that off.  (And TMPFS_POSIX_ACL, too.)
