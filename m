Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2AYQcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:32:36 -0500
Received: from ssl.dlh.net ([91.198.192.8]:34719 "EHLO ssl.dlh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648Ab2AYQcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:32:35 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 11:32:35 EST
Message-ID: <4F202C2E.7040100@dlh.net>
Date: Wed, 25 Jan 2012 17:22:06 +0100
From: Peter Lieven <pl@dlh.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: free page zeroing and ksm
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

working a lot with KVM and KSM I came across the question if Linux (like 
e.g. Windows) zeroes out free pages
after usage. I came across some patches for page sanitization which 
where submitted in 2009 and have not
been merged for various reasons.

Working with memory deduplication the primary goal is not sanitization 
of the pages, but have them not contain
any garbage after they are freed.

My question is if there is any mechanism in Linux to zero out unused 
pages? I found some people claiming that
there is such a mechanism, but I found no reference.

If there is not would it be possible to implement a kernel process that 
scans for unused pages and zeroes them
out during idle time?

Thanks,
Peter
