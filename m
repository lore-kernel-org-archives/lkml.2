Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab1ACFP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 00:15:59 -0500
Received: from lo.gmane.org ([80.91.229.12]:41960 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab1ACFP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 00:15:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: Measuring startup-time from userspace
Date: Mon, 3 Jan 2011 05:12:24 +0000
Message-ID: <oe28v7-g0t.ln1@chipmunk.wormnet.eu>
References: <4D20FEF0.5020206@mozilla.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taras Glek <tglek@mozilla.com> wrote:
>
> Does Linux provide a reasonable way to measure how long a process has 
> existed for? The goal is to have a function that returns the number of 
> milliseconds since process-creation.
>
At a glance:
----
alex@berk:~$ stat /proc/16863/
  File: `/proc/16863/'
  Size: 0               Blocks: 0          IO Block: 1024   directory
Device: 3h/3d   Inode: 837808      Links: 6
Access: (0555/dr-xr-xr-x)  Uid: ( 1000/    alex)   Gid: ( 1000/    alex)
Access: 2011-01-03 05:07:47.888363341 +0000
Modify: 2011-01-03 05:07:47.888363341 +0000
Change: 2011-01-03 05:07:47.888363341 +0000
----

A nanosecond resolution timestamp for the moment when the pid is created 
it seems.  I could be completely wrong, but this seems to be one of 
those "too easy to be true" moments.

Cheers

-- 
Alexander Clouter
.sigmonster says: Marriage is the sole cause of divorce.

