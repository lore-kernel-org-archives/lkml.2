Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2KTNkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:40:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56195 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KTNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:40:39 -0500
Date: Tue, 20 Nov 2012 14:40:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matteo Croce <technoboy85@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Source updater script
Message-ID: <20121120134051.GA8111@elf.ucw.cz>
References: <CAFnufp3SdnBoFiC5j2bjrA=MW-WfsmFVhfggJvoHa-5ZEgg7aA@mail.gmail.com>
 <20121106044346.GA23799@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106044346.GA23799@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-11-06 05:43:46, Greg KH wrote:
> On Tue, Nov 06, 2012 at 12:52:46AM +0100, Matteo Croce wrote:
> > Hi all,
> > 
> > I know that this is useless to people using git, but it was so fun to write
> > and I use it to update regularly my pc kernel source from time to time
> > while saving servers (and home) bandwidth
> 
> Have you looked at the python script called 'ketchup'?  I think it
> already does a lot of what you are doing here.

I tried to get it to work with 3.x kernels, and I don't think I was
successful. Hopefully someone else did the job?

It would be nice to include it in the scripts/ directory, to save
duplicate work. (Or drivers/staging/scripts? :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
