Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0CQDSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:18:12 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:37169 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0CQDSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:18:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=m0lX4wLYzBLErZOP/f8FZcTznhxX5ZDH8cG7nfMtSMHqmrQoqgl9d9nMf9AboAWQAx
         Wf+LSx4UTSJ2ppqP1Qnph9XYqK4bl+DusWRPyfk/UknE0ugvNGvzuh3WxPTA69DksRyD
         4yrFSyhc4RUhOFwRHCOpy8MV22ndN4Bz0n/vQ=
Message-ID: <4ba049f1.017ee70a.5ce6.1456@mx.google.com>
Date: Tue, 16 Mar 2010 20:18:09 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
In-Reply-To: <20100317012439.GA8256@thunk.org>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
	<20100317012439.GA8256@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the lack of any useful information in my initial email.
I clearly didn't read it before sending.

On Tue, 16 Mar 2010 21:24:39 -0400, tytso@mit.edu wrote:
> What kernel version are you using; what distribution and what version
> of that distro are you running; what file system are you using and
> what if any mount options are you using?  And what kind of hard drives
> do you have?

While this problem has been around for some time, my current configuration
is the following:

  Kernel 2.6.32 (although also reproducible with kernels at least as early as 2.6.28)
  Filesystem: Now Btrfs (was ext4 less than a week ago), default mount options
  Hard drive: Seagate Momentus 7200.4 (ST9500420AS)
  Distribution: Ubuntu 9.10 (Karmic)

> 
> I'm going to assume you're running into the standard ext3
> "data=ordered" entagled writes problem.  There are solutions, such as
> switching to using ext4, mounting with data=writeback mode, but they
> have various shortcomings.
> 
Unfortunately several people have continued to encounter unacceptable
latency, even with ext4 and data=writeback.

> A number of improvements have been made in ext3 and ext4 since some of
> the discussions you quoted, but since you didn't tell us what
> distribution version and/or what kernel version you are using, we
> can't tell you are using those newer improvements yet.
>
Sorry about that. I should know better by now.

- Ben
