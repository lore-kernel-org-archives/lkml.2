Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab0EDAoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 20:44:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35449 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab0EDAoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 20:44:03 -0400
Date: Tue, 4 May 2010 01:43:38 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100504004338.GA22678@srcf.ucam.org>
References: <1272667021-21312-1-git-send-email-arve@android.com> <87wrvl5479.fsf@deeprootsystems.com> <20100503180741.GB2098@rakim.wolfsonmicro.main> <201005032318.35383.rjw@sisk.pl> <87sk68r1zh.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sk68r1zh.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 04:37:22PM -0700, Kevin Hilman wrote:

> Please forgive the ignorance of ACPI (in embedded, we thankfully live
> in magical world without ACPI) but doesn't that already happen with
> CPUidle and C-states?  I think of CPUidle as basically runtime PM for
> the CPU.  IOW, runtime PM manages the devices, CPUidle manages the CPU
> (via C-states), resulting in dynaimc PM for the entire system.  What
> am I missing?

ACPI doesn't provide any functionality for cutting power to most devices 
other than shifting into full system suspend. The number of wakeup 
events available to us on a given machine is usually small and the 
wakeup latency large, so it's not terribly practical to do this 
transparently on most hardware.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
