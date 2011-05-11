Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1EKRsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:48:43 -0400
Received: from lo.gmane.org ([80.91.229.12]:39631 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab1EKRsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:48:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ulrich Keller <uhkeller@googlemail.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Date: Wed, 11 May 2011 10:53:18 +0000 (UTC)
Message-ID: <loom.20110511T124036-180@post.gmane.org>
References: <4DAF6C0B.3070009@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 88.68.212.204 (Mozilla/5.0 (X11; Linux i686; rv:2.0.1) Gecko/20110429 Firefox/4.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing exactly the same symptoms on my Lenovo T60 Core2 duo, 3GB RAM,
running Arch Linux i686 with Kernel 2.6.38.6. When I've heavily used Firefox for
a while, or used R with high memory usage (>1 GB), individual applications
become unresponsive, new processes fail to start and after a while the whole
system freezes. When it happens, iotop shows khugepaged and sometimes firefox at
99.99%.

I'd be happy to post information here when the problem occurs again. Anything
other than "cat /proc/zoneinfo"?




