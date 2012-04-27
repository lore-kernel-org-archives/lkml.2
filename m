Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab2D0DB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 23:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab2D0DB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 23:01:57 -0400
Date: Thu, 26 Apr 2012 22:02:24 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: 3.4-rc4 oom killer out of control.
Message-ID: <20120427020224.GA22927@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <20120426193551.GA24968@redhat.com>
 <alpine.DEB.2.00.1204261437470.28376@chino.kir.corp.google.com>
 <20120426215257.GA12908@redhat.com>
 <alpine.DEB.2.00.1204261517100.28376@chino.kir.corp.google.com>
 <20120426224419.GA13598@redhat.com>
 <20120427005448.GD23877@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427005448.GD23877@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 08:54:48PM -0400, Steven Rostedt wrote:
 
 > >  > full_scans is just a counter of how many times it has scanned mergable 
 > >  > memory so it should be increasing constantly.  Whether pages_to_scan == 
 > >  > 1250 and sleep_millisecs == 20 is good for your system is unknown.  You 
 > >  > may want to try disabling ksm entirely (echo 0 > /sys/kernel/mm/ksm/run) 
 > >  > to see if it significantly increases responsiveness for your workload.
 > > 
 > 
 > You didn't happen to see any RCU CPU stalls, did you?

nothing got reported in dmesg..

	Dave
