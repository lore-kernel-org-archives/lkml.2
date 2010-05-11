Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0EKQP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:15:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53032 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0EKQPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:15:25 -0400
Date: Tue, 11 May 2010 17:14:48 +0100
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
Message-ID: <20100511161448.GA16148@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <87632vhbs8.fsf@deeprootsystems.com> <201005102225.52431.rjw@sisk.pl> <20100511161227.GD13600@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511161227.GD13600@atomide.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 11, 2010 at 09:12:28AM -0700, Tony Lindgren wrote:

> To me it sounds like this should only be allowed to happen when you do:
> 
> # echo 1 > /sys/power/suspend_while_idle
> 
> As it kills the timers and leads to non-standard behaviour of the apps
> as they won't run :)
> 
> And then the remaining question is how to make sure the use cases
> below can be handled in a clean way.

That's handled by the /sys/power/policy opportunistic/forced switch.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
