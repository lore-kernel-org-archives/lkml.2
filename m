Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab2KTMVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:21:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2KTMVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:21:31 -0500
Date: Tue, 20 Nov 2012 13:21:15 +0100
From: Karel Zak <kzak@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kerolasa@gmail.com, Sami Kerola <kerolasa@iki.fi>,
        Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: ipc: object information data in proc and sysfs
Message-ID: <20121120122115.GA2006@x2.net.home>
References: <CAG27Bk1q5t590bvGg7Ka+2M-yWEMk_58sZsOxDKx-1XNn8mHww@mail.gmail.com>
 <20121119161250.ae0b25ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119161250.ae0b25ff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 04:12:50PM -0800, Andrew Morton wrote:
> Where's the benefit in switching ipcs over to using /proc?
> 
> procfs reads are probably slower than the syscalls?

 32bit userspace and 64bit kernel (RHEL ppc64), it seems more reliable
 read from /proc than use the syscalls.

 I guess that IPC_64 flag for shmctl() commands is used by libc in 64bit
 userspace only.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
