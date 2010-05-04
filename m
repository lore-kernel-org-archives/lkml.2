Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550Ab0EDTHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:07:16 -0400
Received: from mail.perches.com ([173.55.12.10]:1908 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab0EDTHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:07:14 -0400
Subject: Re: Staging: dt3155: Cleanup memory mapped i/o access
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@suse.de>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       "ss@aao.gov.au" <ss@aao.gov.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100504025430.GA26421@suse.de>
References: <0D753D10438DA54287A00B0270842697636DAFCD14@AUSP01VMBX24.collaborationhost.net>
	 <20100430215645.GA12409@kroah.com>
	 <0D753D10438DA54287A00B0270842697636E9B9B0D@AUSP01VMBX24.collaborationhost.net>
	 <20100503185933.GA27346@kroah.com>
	 <0D753D10438DA54287A00B0270842697636EADDEC0@AUSP01VMBX24.collaborationhost.net>
	 <20100503211751.GB21402@kroah.com>
	 <0D753D10438DA54287A00B0270842697636EADE1D2@AUSP01VMBX24.collaborationhost.net>
	 <0D753D10438DA54287A00B0270842697636EADE26A@AUSP01VMBX24.collaborationhost.net>
	 <20100503234123.GC13519@suse.de>
	 <1272931198.30040.218.camel@Joe-Laptop.home>
	 <20100504025430.GA26421@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 12:07:11 -0700
Message-ID: <1273000031.4143.56.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-03 at 19:54 -0700, Greg KH wrote: 
> > git push?
> I have, and they look to be there to me:
>   http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-next-2.6.git;a=commit;h=4f923d004396ef272600d381a365cac9d832486d
> So something must be odd on your side.

Yup, sorry, my mistake.

staging-next is the name of your repository as well as
a branch within your repository and git after git clone
doesn't by default show all remote branches.

$ git clone --reference=linux-2.6 \
	git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git

$ git branch -r
  origin/HEAD -> origin/master
  origin/master
  origin/staging-next

I needed to add a git checkout origin/staging-next


