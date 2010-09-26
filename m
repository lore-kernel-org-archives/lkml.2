Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab0IZBcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 21:32:31 -0400
Received: from mail.perches.com ([173.55.12.10]:2399 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab0IZBc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 21:32:29 -0400
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
From: Joe Perches <joe@perches.com>
To: "Ted Ts'o" <tytso@mit.edu>, Andy Whitcroft <apw@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>, T Dent <tdent48227@gmail.com>,
        adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100926010410.GC19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <20100925233600.GA2854@lst.de>
	 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de> <20100926000154.GB5299@thunk.org>
	 <1285459769.6115.74.camel@Joe-Laptop> <20100926003255.GA19690@thunk.org>
	 <1285462243.6115.89.camel@Joe-Laptop>  <20100926010410.GC19690@thunk.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 18:32:26 -0700
Message-ID: <1285464746.6115.108.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-25 at 21:04 -0400, Ted Ts'o wrote:
> But the stupid thing is
> trying to do it on a file-by-file basis in the first place, when for
> something like fs/ext4, it really should be done on a subdirectory
> basis.

That's not true at all.

If there's a listed maintainer linked to a pattern
like "F: fs/ext4/", then all files in that
directory and any subdirectories are "maintained".

If a maintainer wants to "exclude" particular files,
or subdirectories, that's possible with the "X:" tag.

> What really annoys me is newbies who use checkpatch.pl in its --file
> mode, and then assume that every single warning is a deadly bug that
> much be patched.

Perhaps checkpatch.pl should print some "don't submit
patches for stupid stuff" when used with -f.

> I at least never use it.

Nor are you required to.

Tool use is optional.  I don't care if you carve
patches with a mallet onto stone tablets and send
them by swarms of carrier pigeon to Linus so can
reuse the stone to build an actual castle.

cheers, Joe

