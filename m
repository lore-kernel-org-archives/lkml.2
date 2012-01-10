Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2AJJmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 04:42:23 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:42349 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab2AJJmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 04:42:21 -0500
Message-ID: <4F0C07E1.8050604@parallels.com>
Date: Tue, 10 Jan 2012 13:41:53 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Adrian Reber <adrian@lisas.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        "matt.helsley@gmail.com" <matt.helsley@gmail.com>,
        =?ISO-8859-1?Q?Peter_?= =?ISO-8859-1?Q?V=E4terlein?= 
	<Peter.Vaeterlein@hs-esslingen.de>
Subject: Re: linux-cr ported to 3.2-rc1
References: <20111114151300.GT16442@lisas.de> <4EC131A3.9050504@parallels.com> <20120105210752.GC12072@lisas.de>
In-Reply-To: <20120105210752.GC12072@lisas.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The first set of patches in my current patchset tries to implement
> eclone() which provides the clone() functionality but with the
> possibility to request a certain PID so that child processes can be
> restarted with the same PID. How are you planning to restart child
> processes?

With the /proc/sys/kernel/ns_last_pid helper.

> Are those patches maybe something which makes also sense for your C/R implementation?

The sources are here:
Kernel with all the patches we want:
  https://github.com/cyrillos/linux-2.6/tree/crtools
User-space part:
  https://github.com/cyrillos/crtools
Documentation:
  http://criu.org

> 		Adrian
> .
> 

