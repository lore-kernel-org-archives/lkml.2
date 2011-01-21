Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab1AUUkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:40:37 -0500
Received: from mail.openrapids.net ([64.15.138.104]:37123 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752282Ab1AUUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:40:35 -0500
Date: Fri, 21 Jan 2011 15:40:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Richard Mortimer <richm@oldelvet.org.uk>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110121204033.GA14125@Krystal>
References: <20110119221327.GA23544@Krystal> <20110119.142137.184823805.davem@davemloft.net> <20110119223339.GD23544@Krystal> <20110119.164107.135521108.davem@davemloft.net> <20110121000421.GA5014@Krystal> <4D39CB0C.8070308@oldelvet.org.uk> <20110121185259.GA13198@Krystal> <4D39E913.8060104@oldelvet.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D39E913.8060104@oldelvet.org.uk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:37:01 up 59 days,  1:40,  4 users,  load average: 0.31, 0.08,
	0.02
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Mortimer (richm@oldelvet.org.uk) wrote:
[...]
> P.S. I saw your followup mail so hopefully this matches what you have found!

Thanks for the info! At first glance, it does not seem to contradict my
findings. When you find time, can you have a try at v3 I just posted ?

Make sure to start tracing in your tests, as I think the unaligned access only
happens when accessing the struct tracepoint fields below the "int state" field.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
