Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0EKSSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:18:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43102 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756983Ab0EKSSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:18:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Tue, 11 May 2010 20:19:02 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>
References: <87wrvl5479.fsf@deeprootsystems.com> <20100511172442.GB13931@atomide.com> <20100511173036.GB17868@srcf.ucam.org>
In-Reply-To: <20100511173036.GB17868@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005112019.02670.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 May 2010, Matthew Garrett wrote:
> On Tue, May 11, 2010 at 10:24:43AM -0700, Tony Lindgren wrote:
> 
> > For the failed suspend path in the kernel, currently the kernel would
> > unwind back all the drivers because of the failed driver, but that path
> > should be possible to optimize.
> 
> If you think it's possible to make this work then feel free to. But at 
> the point where you're adding code to every driver's suspend function to 
> determine whether or not it's got any pending events that userspace 
> hasn't consumed yet, and adding code to every bit of userspace to allow 
> it to indicate whether or not it's busy consuming events or just busy 
> drawing 3D bouncing cattle, I think you've reinvented suspend blocks.

Yeah, pretty much so.

Thanks,
Rafael
