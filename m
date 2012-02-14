Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133Ab2BNVMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:12:37 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43287 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab2BNVMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:12:36 -0500
Date: Tue, 14 Feb 2012 21:12:32 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com, vgoyal@redhat.com,
        seiji.aguchi@hds.com
Subject: Re: [PATCH V3] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120214211232.GB2750@srcf.ucam.org>
References: <1328888715-21589-1-git-send-email-mjg@redhat.com>
 <20120214130522.fdb05b81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214130522.fdb05b81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 01:05:22PM -0800, Andrew Morton wrote:

> So if I'm understanding it correctly, this patch reverts the kernel
> behaviour to what it was before 04c6862c055fb687c9 ("kmsg_dump: add
> kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart
> paths").  The user must now set printk.always_kmsg_dump to get the
> 04c6862c055fb687c9 behaviour.

Correct.

> Correct?  If so, we should get this into 3.3 so we don't have a oddball
> behaviour in one particular kernel release.

That would be my preference.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
