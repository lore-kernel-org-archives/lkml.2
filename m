Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab2AHR57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 12:57:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab2AHR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 12:57:58 -0500
Date: Sun, 8 Jan 2012 09:56:45 -0800
From: Greg KH <gregkh@suse.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4] sysfs:  Reduce the size of sysfs_dirent
Message-ID: <20120108175645.GC29499@suse.de>
References: <m1aa6pky2r.fsf@fess.ebiederm.org>
 <m1sjjwggz0.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sjjwggz0.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 09:43:47PM -0800, Eric W. Biederman wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:
> 
> > After throwing rb_trees at the problem sysfs_dirent increased in size by
> > 6 pointers, or 48 bytes.    Since the point of having struct
> > sysfs_dirent is to keep the size down increasing in size that much seems
> > unfortunate.
> >
> > The following patches attack this problem and if I have counted right
> > reduce the size of sysfs_dirent by 4 pointers on 64bit.  Not quite
> > where we were but reducing sysfs_dirent by 32bytes to 104 bytes is
> > an improvement.
> 
> Greg did you see these patches for reducing the sysfs memory size
> regression in 3.2?

Ok, due to the holidays, these ended up missing the 3.3 merge window,
I'll queue them up for 3.4.

thanks,

greg k-h
