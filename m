Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1HZJpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:45:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:38302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab1HZJpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:45:16 -0400
Subject: Re: [V3][PATCH 0/6] x86, nmi: new NMI handling routines
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Date: Fri, 26 Aug 2011 11:44:57 +0200
In-Reply-To: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314351897.9377.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 12:45 -0400, Don Zickus wrote:
> I spent some time hacking and came up with this patch.  I tested it on my
> core2quad machine trying to enable all the NMI handler I could, mainly
> perf and kgdb (and oprofile too when perf was disabled).  Everything seems
> to work correctly.  If people are ok with this approach, I'll try and test
> this on more machines. 

Right, code looks OK, the only worry that remains is overhead, always
running all handlers must cost..
