Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161000Ab2CSOpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:45:45 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:52328 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030834Ab2CSOpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:45:44 -0400
Message-ID: <4F674696.7030602@xenotime.net>
Date: Mon, 19 Mar 2012 07:45:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1332152728-4027-1-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 03:25 AM, Steven Whitehouse wrote:

> Hi,
> 
> Not a huge number of patches this time. Some notable new features
> though:
>  - Glock stats gathering (v. useful for performance analysis)
>  - FITRIM ioctl support
>  - Sorting the ordered write list (big performance increase when the workload
>    doesn't result in the write requests being nicely ordered to start with)
> 
> Plus a few clean ups, and bug fixes in addition,



Hi,

I reported a build error in linux-next 20120313, but it appears
that mainline also needs the fix (when it's ready) since mainline
gfs2 Kconfig selects DLM_SCTP, which does not exist.

https://lkml.org/lkml/2012/3/13/456

-- 
~Randy
