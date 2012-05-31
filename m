Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab2EaMBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:01:23 -0400
Received: from plane.gmane.org ([80.91.229.3]:60958 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756870Ab2EaMBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:01:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: git <8f6576a> Causes non-interruptible stalls in NFS clients
Date: Thu, 31 May 2012 05:01:01 -0700
Message-ID: <4FC75D7D.6060002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-178-9.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge: 8f6576a cc0a984
Author: Linus Torvalds 
Date:   Tue May 29 10:43:51 2012 -0700

    Merge tag 'nfs-for-3.5-1' of git://git.linux-nfs.org/projects/trondmy/linux-nfs
    
    Pull NFS client updates from Trond Myklebust:

- Improve the code sharing between NFSv2/v3 and v4 mounts


That last comment gave me the idea to enable NFSv4 client support in my kernel
(which I had disabled many months ago because of NFSv4 weirdness).

Enabling NFSv4 client support completely fixed the non-interruptible NFS stalls
and, strangely, also fixed the very similar stalls in my scp/sftp clients when
pushing files > 800KB or so.

Enabling the NFSv4 client support fixes everything even though I'm still using
NFSv3 mounts explicitly/exclusively.

