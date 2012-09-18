Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab2IRWQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:16:09 -0400
Received: from bsmtp5.bon.at ([195.3.86.187]:26512 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932173Ab2IRWQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:16:07 -0400
X-Greylist: delayed 1672 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2012 18:16:06 EDT
From: Markus Grabner <grabner@icg.tugraz.at>
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: staging: Line6 - Steps needed to get driver out of staging area
Date: Tue, 18 Sep 2012 23:48:05 +0200
Message-ID: <8819852.fHKccXL5At@medialab>
User-Agent: KMail/4.9.1 (Linux/3.4.6-2.10-desktop; KDE/4.9.1; x86_64; ; )
In-Reply-To: <50582B75.7080608@gmail.com>
References: <50560C5F.3020700@gmail.com> <20120917202238.GA18748@kroah.com> <50582B75.7080608@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. September 2012, 10:06:13 schrieb Johannes Thumshirn:
> On 09/17/2012 10:22 PM, Greg KH wrote:
> > On Sun, Sep 16, 2012 at 07:29:03PM +0200, Johannes Thumshirn wrote:
> >> Hi LKML,
> >> 
> >> I wanted to ask for the steps that are needed to get the line6
> >> driver out of the staging area (apart from minor getpatch.pl fixes).
> > 
> > First try asking on the proper mailing list :)
> > 
> > Second, it needs to be submitted to the subsystem that it should be in
> > (i.e. sound, right?)  It's up to those maintainers to say what's left to
> > do.
> > 
> > Are you willing to help out with this?  Right now it doesn't seem like
> > anyone is using the driver, or helping to clean it up.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Ok, then I'll ask on the sound mailing list for a todo-list.
> 
> Yes I'm willing to do the maintenance of this driver if the original
> author doesn't want to take it up again.
It's absolutely ok for me if you do the maintainance of the driver within the 
Linux kernel tree, including the steps needed to get it out of staging. There 
are actually people using it, occasionally I get requests regarding the 
driver. However, since the Line6 devices available to me for development and 
testing are rather old now, I can't contribute too much to adding support for 
newer devices. Other users provided code which, according to the feedback I 
received, works well for more recent devices. Nevertheless, I have some ideas 
to improve the driver in areas I can test myself, so I won't completely 
withdraw from development.

	Kind regards,
		Markus

