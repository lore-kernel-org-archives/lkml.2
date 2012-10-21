Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2JUK0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:26:50 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35600 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2JUK0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:26:49 -0400
Date: Sun, 21 Oct 2012 12:26:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Sooman Jeong <77smart@hanyang.ac.kr>, linux-kernel@vger.kernel.org
Subject: Re: Initial report on F2FS filesystem performance
Message-ID: <20121021102638.GA14031@elf.ucw.cz>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
 <20121020192215.GB555@elf.ucw.cz>
 <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> This is a brief summary of our initial filesystem performance study of f2fs against existing two filesystems in linux: EXT4, NILFS2, and f2fs.
> >> 
> > 
> > Hmm, flashes are actually optimized for VFAT, right? Can you compare
> > against that?
> > 
> 
> Do you mean SD-cards? Because, as I can understand, "raw" flash (I mean NAND chip) hasn't any special filesystem-related optimization. Moreover, as I know, this optimization takes place in the begin of device (because FAT metadata is placed in the volume's begin). But if you have several partition on a device then you haven't any optimizations for second and next FAT partitions. So, in-place modified metadata of f2fs is placed in the begin of the volume also.
> 
> Or, maybe, do you mean some another special optimization for VFAT? 
> 

I meant SD-card, sorry. Compare factory-formatted VFAT on SD card with
f2fs running on the same partition.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
