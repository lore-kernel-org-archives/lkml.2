Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab0EGDwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 23:52:44 -0400
Received: from smtpauth18.prod.mesa1.secureserver.net ([64.202.165.31]:35236
	"HELO smtpauth18.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753871Ab0EGDwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 23:52:36 -0400
Date: Thu, 6 May 2010 20:45:10 -0700
From: mgross <markgross@thegnar.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Tony Lindgren <tony@atomide.com>, Brian Swetland <swetland@google.com>,
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
Message-ID: <20100507034510.GA20935@thegnar.org>
Reply-To: markgross@thegnar.org
References: <20100505202826.GB7450@linux.intel.com>
 <Pine.LNX.4.44L0.1005051705200.1885-100000@iolanthe.rowland.org>
 <z2ta55d774e1005051437heb584584q6afca0b4b254d5d0@mail.gmail.com>
 <20100505234755.GI29604@atomide.com>
 <20100506134015.GA23426@srcf.ucam.org>
 <20100506170151.GA30928@atomide.com>
 <20100506170956.GA28104@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506170956.GA28104@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 06:09:56PM +0100, Matthew Garrett wrote:
> On Thu, May 06, 2010 at 10:01:51AM -0700, Tony Lindgren wrote:
> 
> > Or are you suspending constantly, tens of times per minute even if
> > there's no user activity?
> 
> In this case you'd be repeatedly trying to suspend until the modem 
> driver stopped blocking it. It's pretty much a waste.


lets not go off in the weeds for the wrong things now.  The answer to
the retry is at most one time.  The first time would be blocked, then
the suspend enable would need to re-enabled under user mode control that
would, buy that time, know it has to ack to the modem to stop rejecting
the suspend attempt.

duh.

--mgross
