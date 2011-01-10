Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1AJHsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 02:48:13 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:43963 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751677Ab1AJHsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 02:48:12 -0500
Date: Mon, 10 Jan 2011 08:48:10 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Dan Carpenter <error27@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Subject: Re: ext3: deleting files doesn't free up space
Message-ID: <20110110074810.GB21505@bitwizard.nl>
References: <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimwDpUz9GUmx3UutYir0UuoTSAXNzphWeEX9sKh@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 08:22:25AM +0300, Dan Carpenter wrote:
> I filled up my partition last night.
> I deleted 5 gigs of movies.
> The "Used" number went down to 125G.
> The "Free" number stayed at 0.
> I rebooted the system but it's still the same.

Hi Dan, 

The system keeps at least 5 or 10% of the total space free so that it
will always be able to find a reasonably unfragmented spot for a new
big file. That same 5 or 10% CAN be written by the root-user in
emergencies. But "root" should know it can affect the peformance of
his filesystem. Anyway, because you're still using part of the 5 - 10%
reserved-for-performance reasons, "df" will report the user-available
space as zero. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
