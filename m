Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760311Ab2CaPqm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 11:46:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56341 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191Ab2CaPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 11:46:39 -0400
Date: Sat, 31 Mar 2012 19:46:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: reset mount options after the last procfs umount
Message-ID: <20120331154625.GA6241@albatros>
References: <201203220903.15360.a.miskiewicz@gmail.com>
 <201203311619.38921.a.miskiewicz@gmail.com>
 <20120331152039.GA4674@albatros>
 <201203311731.42388.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201203311731.42388.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 17:31 +0200, Arkadiusz Miśkiewicz wrote:
> On Saturday 31 of March 2012, Vasiliy Kulikov wrote:
> > On Sat, Mar 31, 2012 at 16:19 +0200, Arkadiusz Miśkiewicz wrote:
> > > "after all procs are umounted". For me such way is fine but still can
> > > suprise people.
> > > 
> > > Anyway - what's the problem with implementing support for separate
> > > options for each mount point?
> > 
> > Well, IMHO multiple procs in one pid namespace is a very strange system
> > configuration.  I didn't see such installations. 
> 
> I have one real world case - linux-vserver.org guests where pid namespace is 
> optional and usually not used.

I'm a vserver noob.  Does it allow using multiple containers sharing the same
pid namespace?  Having only a single init process?

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
