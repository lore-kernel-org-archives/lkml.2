Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab0EKREM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 13:04:12 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51529 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab0EKREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 13:04:09 -0400
Date: Tue, 11 May 2010 18:03:48 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100511170348.GA17443@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <87632vhbs8.fsf@deeprootsystems.com> <201005102225.52431.rjw@sisk.pl> <20100511161227.GD13600@atomide.com> <20100511161448.GA16148@srcf.ucam.org> <20100511163632.GE13600@atomide.com> <20100511164554.GA17016@srcf.ucam.org> <20100511165821.GA13931@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511165821.GA13931@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:58:21AM -0700, Tony Lindgren wrote:
> * Matthew Garrett <mjg@redhat.com> [100511 09:41]:
> > Yes. You still need suspend blocks.
> 
> Maybe not if echo opportunistic > /sys/power/policy gets cleared by
> the kernel if the kernel idle loop can't make it. That means something
> has blocked the suspend attempt in a driver for example. The system
> keeps running, and the userspace can deal with the situation.

So an event arrives just as userspace does this write. How do you avoid 
the race? Plausible answers mostly appear to end up looking like suspend 
blockers.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
