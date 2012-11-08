Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab2KHWVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 17:21:05 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:60109 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180Ab2KHWVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:03 -0500
Date: Thu, 8 Nov 2012 11:04:58 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Luming Yu <luming.yu@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] A simple hardware detector for latency as well as
 throughtput ver 0.10
Message-ID: <20121108160458.GC766@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Luming Yu <luming.yu@gmail.com>, arnd@arndb.de,
	linux-kernel@vger.kernel.org
References: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352080784-30839-1-git-send-email-luming.yu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 08:59:31PM -0500, Luming Yu wrote:
> Back to July of this year, I sent the first round of the tool.
> Now I've polished it a little bit.
> 
> The patch is the fist step to test some basic hardware functions like
> TSC to help people understand if there is any hardware latency as well
> as throughput problem exposed on bare metal or left behind by BIOS or
> interfered by SMI. Currently the patch tests TSC, CPU Frequency, and
> RDRAND, which is a new CPU instruction to get random number introudced
> in new CPU like Intel Ivy Bridge, in stop_machine context.

You are adding a new file, drivers/misc/hw_latency_test.c to the
kernel.  I don't think it makes sense to include the file, and then
follow it with 12 patches which modify the file.  You don't need to
"show your work" with the various bug fixes that has been made since
July.  I'd recommend collapsing all of the collected patches plus the
base file into a single commit.

Regards,

						- Ted
