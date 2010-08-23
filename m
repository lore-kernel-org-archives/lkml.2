Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab0HWWrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 18:47:05 -0400
Received: from kroah.org ([198.145.64.141]:38447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0HWWrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 18:47:04 -0400
Date: Mon, 23 Aug 2010 15:27:26 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Greg KH <gregkh@suse.de>, "Gabor Z. Papp" <gzp@papp.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.52 stable review
Message-ID: <20100823222726.GE13371@kroah.com>
References: <20100813214704.GA18960@kroah.com>
 <x6r5i1o3dc@gzp>
 <20100814210135.GA7745@suse.de>
 <4C671497.4050701@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C671497.4050701@mandriva.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 01:11:35AM +0300, Thomas Backlund wrote:
> Greg KH skrev 15.8.2010 00:01:
> >On Sat, Aug 14, 2010 at 01:11:43PM +0200, Gabor Z. Papp wrote:
> >>* Greg KH<gregkh@suse.de>:
> >>
> >>| If I could get some people to please test this -rc release?
> >>
> >>BTW seems like 2.6.27 no more combatible with GNU Make 3.82:
> >>
> >>$ make oldconfig
> >>Makefile:443: *** mixed implicit and normal rules.  Stop.
> >>
> >>Same with line 1609.
> >
> >Nothing has changed with the main Makefile with the exception of
> >changing the version number for a very long time.
> >
> >Did something else change on your system?
> >
> >odd,
> >
> 
> 2.6.27 needs this wich went in after 2.6.28-rc8:
> 
> kbuild: fix make incompatibility
> author	Sam Ravnborg <sam@ravnborg.org>	
> 	Sat, 13 Dec 2008 22:00:45 +0000 (23:00 +0100)
> committer	Sam Ravnborg <sam@ravnborg.org>	
> 	Sat, 13 Dec 2008 22:00:45 +0000 (23:00 +0100)
> commit	31110ebbec8688c6e9597b641101afc94e1c762a

Now applied.

thanks,

greg k-h
