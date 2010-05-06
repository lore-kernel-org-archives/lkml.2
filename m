Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab0EFSot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:44:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54553 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0EFSos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:44:48 -0400
Date: Thu, 6 May 2010 19:44:18 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100506184418.GA30669@srcf.ucam.org>
References: <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com> <20100505234755.GI29604@atomide.com> <20100506134015.GA23426@srcf.ucam.org> <20100506170151.GA30928@atomide.com> <20100506170956.GA28104@srcf.ucam.org> <20100506171453.GC30928@atomide.com> <20100506172201.GA28578@srcf.ucam.org> <20100506173807.GD30928@atomide.com> <20100506174331.GA29103@srcf.ucam.org> <20100506183335.GE30928@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506183335.GE30928@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 11:33:35AM -0700, Tony Lindgren wrote:
> * Matthew Garrett <mjg@redhat.com> [100506 10:39]:
> > On Thu, May 06, 2010 at 10:38:08AM -0700, Tony Lindgren wrote:
> > 
> > > If your userspace keeps polling and has runaway timers, then you
> > > could suspend it's parent process to idle the system?
> > 
> > If your userspace is suspended, how does it process the events that 
> > generated a system wakeup? If we had a good answer to that then suspend 
> > blockers would be much less necessary.
> 
> Well if your hardware runs off-while-idle or even just
> retention-while-idle, then the basic shell works just fine waking up
> every few seconds or so.

And the untrusted userspace code that's waiting for a network packet? 
Adding a few seconds of latency isn't an option here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
