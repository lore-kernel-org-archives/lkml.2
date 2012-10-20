Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab2JTTWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 15:22:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57730 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2JTTWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 15:22:20 -0400
Date: Sat, 20 Oct 2012 21:22:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sooman Jeong <77smart@hanyang.ac.kr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Initial report on F2FS filesystem performance
Message-ID: <20121020192215.GB555@elf.ucw.cz>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-10-16 13:07:03, Sooman Jeong wrote:
> 
> This is a brief summary of our initial filesystem performance study of f2fs against existing two filesystems in linux: EXT4, NILFS2, and f2fs.
> 

Hmm, flashes are actually optimized for VFAT, right? Can you compare
against that?

What about something more complex like "untar of kernel tree"?

Ouch and... thanks for doing this.
									Pavel     
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
