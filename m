Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2BAQbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:31:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44118 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab2BAQbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:31:34 -0500
Date: Wed, 1 Feb 2012 08:31:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <paul@paulmenage.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Tim Hockin <thockin@hockin.org>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@gmail.com>, Cgroups <cgroups@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Max Kellermann <mk@cm4all.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v8
Message-ID: <20120201163126.GA19837@google.com>
References: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328067470-5980-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:37:40AM +0100, Frederic Weisbecker wrote:
> Changes In this version:
> 
> - Split 32/64 bits version of res_counter_write_u64() [1/10]
>   Courtesy of Kirill A. Shutemov
> 
> - Added Kirill's ack [8/10]
> 
> - Added selftests [9/10], [10/10]
> 
> Please consider for merging. At least two users want this feature:

Has there been further discussion about this approach?  IIRC, we
weren't sure whether this should be merged.

Thanks.

-- 
tejun
