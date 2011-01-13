Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab1AMR40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:56:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43528 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081Ab1AMR4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:56:24 -0500
Date: Thu, 13 Jan 2011 17:56:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113175618.GA23497@srcf.ucam.org>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com> <20110113164616.GB21289@srcf.ucam.org> <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6> <20110113173921.GA22823@srcf.ucam.org> <AANLkTimk_Y4Q_cxg1SJxZiTT2gT9ywr5UGmsqPqwmeCy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimk_Y4Q_cxg1SJxZiTT2gT9ywr5UGmsqPqwmeCy@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:53:46AM -0600, Manoj Iyer wrote:
>    early-quirks.c ignores all rev ids greater than 14. I thought the fix
>    should be more dmi based rather than rev I'd based.

If we're seeing the same problem with later revisions then it's either a 
bug in the quirk or it's something different that has similar behaviour. 
What's the actual failure mode?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
