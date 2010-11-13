Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab0KMHX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:23:27 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56702 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0KMHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:23:25 -0500
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4CDE2B33.9050404@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site>
	 <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
	 <20101113042821.GE18258@parisc-linux.org>
	 <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com>
	 <1289628103.3015.608.camel@mulgrave.site>  <4CDE2B33.9050404@garzik.org>
Content-Type: text/plain
Date: Fri, 12 Nov 2010 23:18:12 -0800
Message-Id: <1289632692.22107.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 01:07 -0500, Jeff Garzik wrote:
> On 11/13/2010 01:01 AM, James Bottomley wrote:
> > I'd like to get rid of done too.  I'm ambivalent on whether we pass in
> > the host or not, but I did it anyway.
> >
> > The patch is reasonably small but there are a few driver prototypes to
> > clean up as well.  How does the attached look? If OK, I'll fold it in
> > and resubmit the pull.
> >
> > I think I picked up all the non-x86 drivers that don't show up under
> > allmodconfig, but it would be nice to incubate this in next for another
> > couple of days to be sure.
> 
> Looks like you caught the megaraid deadlock, but missed a few others... 
>   I'll rediff mine as incremental as discussed on IRC.

Great, thanks for jumping on this everyone..

I will await Jeff's v5 pull request to linus and rebase the atomic_t
host->cmd_serial_number counter + first round of host_lock-less LLDs
conversions patches on this code for the lock_less-LLDs-for-38-v2.

--nab


