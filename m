Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab1FJQBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 12:01:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38412 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab1FJQAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 12:00:55 -0400
Date: Fri, 10 Jun 2011 16:59:54 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110610155954.GA25774@srcf.ucam.org>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110528005640.9076c0b1.akpm@linux-foundation.org>
 <20110609185259.GA29287@linux.vnet.ibm.com>
 <BANLkTinxeeSby_+tta8EhzCg3VbD6+=g+g@mail.gmail.com>
 <20110610151121.GA2230@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610151121.GA2230@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 08:11:21AM -0700, Paul E. McKenney wrote:

> Of course, on a server, you could get similar results by having a very
> large amount of memory (say 256GB) and a workload that needed all the
> memory only occasionally for short periods, but could get by with much
> less (say 8GB) the rest of the time.  I have no idea whether or not
> anyone actually has such a system.

For the server case, the low hanging fruit would seem to be 
finer-grained self-refresh. At best we seem to be able to do that on a 
per-CPU socket basis right now. The difference between active and 
self-refresh would seem to be much larger than the difference between 
self-refresh and powered down.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
