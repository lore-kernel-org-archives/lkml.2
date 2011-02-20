Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913Ab1BTAFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 19:05:54 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:58762 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1BTAFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 19:05:53 -0500
Date: Sat, 19 Feb 2011 19:05:50 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: ext4 crash on 2.6.37: NULL ptr in ext4_discard_preallocations
Message-ID: <20110220000550.GA8765@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>, Mark Lord <kernel@teksavvy.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
References: <4D604620.9060204@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D604620.9060204@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 05:37:20PM -0500, Mark Lord wrote:
> 32-bit x86 system, 2.6.37 SMP kernel, Core2duo, 3.3GB RAM, no swap.
> 
> The system just suddenly switched to fbconsole and dumped a traceback.
> Here's the screen-shot photo:  http://rtr.ca/ext4_crash.jpg
> 
> Is this a known bug that got fixed in 2.6.37.1 ?

No, this looks like a new one.

And I can't make the Code: line make sense.  Can you send me the
fs/ext4/mballoc.s file after running the command "make
fs/ext4/mballoc.s" in your build tree where you built this kernel?

Thanks!!

						- Ted
