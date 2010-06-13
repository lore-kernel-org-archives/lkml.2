Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0FMXiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 19:38:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59958 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab0FMXiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 19:38:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: BUG: using smp_processor_id() in preemptible code: s2disk
Date: Mon, 14 Jun 2010 01:36:18 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20100613203352.GA3577@swordfish> <1276461183.2659.4.camel@maxim-laptop>
In-Reply-To: <1276461183.2659.4.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006140136.18652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 13, 2010, Maxim Levitsky wrote:
> On Sun, 2010-06-13 at 23:33 +0300, Sergey Senozhatsky wrote: 
> > Hello,
> > 
> > .35-rc3, x86
> > 
> > Hit the following error today:
> 
> I confirm the same issue. Sorry for not reporting it earlier.

It looks like a cpufreq issue to me, but it may be related to CPU hotplug as
well.  I'm not sure who's been messing up with that recently, though.

Rafael
