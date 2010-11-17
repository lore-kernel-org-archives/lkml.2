Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935463Ab0KQUBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:01:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:56490 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935449Ab0KQUBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:01:31 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1290023834.2109.1240.camel@laptop>
References: <1289339119.2191.92.camel@laptop>
	 <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
	 <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop>
	 <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com>
	 <1289421164.2084.56.camel@laptop>
	 <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
	 <1289423135.2084.63.camel@laptop>  <4CE33F86.7040403@linux.vnet.ibm.com>
	 <1289993128.2109.714.camel@laptop>  <4CE43153.2070206@linux.vnet.ibm.com>
	 <1290023834.2109.1240.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 21:01:12 +0100
Message-ID: <1290024072.2109.1247.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 20:57 +0100, Peter Zijlstra wrote:
> > How about a compromise position: all of the arch-specific events are 
> > exposed to user space via sysfs iff some CONFIG_* variable to set to 
> > true.  Something like CONFIG_EXPOSE_ALL_HW_PERF_EVENTS_IN_SYSFS.
> > This way you would only use all that memory when it's explicitly 
> > configured in. 

Another thing you could do is make all PMU drivers loadable modules
(most of the infrastructure for that is present) and make the exhaustive
list either a module parameter or another module extending the PMU
driver.


