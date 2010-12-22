Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0LVWqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 17:46:04 -0500
Received: from dtp.xs4all.nl ([80.101.171.8]:39713 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751637Ab0LVWqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 17:46:03 -0500
Date: Wed, 22 Dec 2010 23:46:01 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: David Rees <drees76@gmail.com>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, linux-kernel@vger.kernel.org
Subject: Re: Slow disks.
Message-ID: <20101222224601.GF30941@bitwizard.nl>
References: <20101220141553.GA6088@bitwizard.nl> <AANLkTikC0gDixPMaj3zZJ9ew7wYx81Ern60omnig-S7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikC0gDixPMaj3zZJ9ew7wYx81Ern60omnig-S7c@mail.gmail.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 12:52:08PM -0800, David Rees wrote:
> On Mon, Dec 20, 2010 at 6:15 AM, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> > A friend of mine has a server in a datacenter somewhere. His machine
> > is not working properly: most of his disks take 10-100 times longer
> > to process each IO request than normal.
> 
> I've seen noticeable slowdowns before when the disks were running long
> SMART tests.  It doesn't seem to affect all drives the same.  The
> smartctl data you posted didn't say whether or not the disks were
> currently running a SMART test, but it's worth double checking.

No, the machine has trouble 24/7, I seriously doubt that it would be
running smart tests 24/7. 

	Roger. 

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
