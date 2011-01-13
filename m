Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab1AMQq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:46:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60839 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab1AMQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:46:21 -0500
Date: Thu, 13 Jan 2011 16:46:16 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113164616.GB21289@srcf.ucam.org>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 10:02:22AM -0600, Manoj Iyer wrote:
> Set acpi_skip_timer_override to force ignoring BIOS
> IRQ0 pin2 override. This fixes resume from suspend on
> AMD based ThinkPad Edge 11,13,14 and 15.

This was originally there because of a quirk in some ati chipsets, 
coupled with DSDT insanity on HP's part. The Thinkpad Edges seem to be 
Intel machines, so it's not the same underlying issue. Do we have any 
idea what the root cause of the failure is? Quirking is a massively less 
than ideal solution.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
