Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab0CaUbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:31:48 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:34205 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab0CaUbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:31:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=rmB3mpSpx+VIRQ8H5bK/BSSKkKkvZ9iELhRqyyHm9DeZ8hXCHqDyEcvXnFNCr3L5/i
         DVqhbqEqgWzE/qbgZpGOWu1m1Vl8Ej8RwyNaDoKUCjwkH7FnMxfguREwjBJLbxDGmyO5
         4q0J/UP0hTrz7U5uxLiHVJEth1sR+/npyJd3s=
MIME-Version: 1.0
Date: Wed, 31 Mar 2010 16:24:09 -0400
Message-ID: <m2v100eff551003311324tdc2e567atd2a48e35520e8601@mail.gmail.com>
Subject: Questions about RAID and I/O scheduler
From: Yuehai Xu <yuehaixu@gmail.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yhxu@wayne.edu, czoccolo@gmail.com,
       neilb@suse.de, jens.axboe@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that some one said NOOP is usually the default I/O scheduler
for hardware RAID. Why not CFQ? Suppose there are just several
sequential read processes, as I know CFQ will keep all the disk heads
of hard raid to serve a process for a while(a time slice), in that
case, CFQ should be the best of all I/O schedulers. Am I right?
Generally, hard raid should have its own I/O scheduler in their
firmware, in that case, the I/O scheduler of OS should do nothing
except dispatch the requests as soon as possible, it is the hard raid
itself to decide how to schedule these requests. From this point of
view, NOOP should be the default one. I am really confused here.

The next question is about the maximal number of disks in disk array,
the fault tolerance should be one limitation because the more the
number of disks, the higher chance of failure. However, may throughput
also be one limitation? Do you know anyone use disk array which
contains large number of disks to handle small requests? Such as 256
disks to handle 4K requests?

Thanks!

Yuehai
