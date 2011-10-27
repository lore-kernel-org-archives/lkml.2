Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1J0Ujw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 16:39:52 -0400
Received: from bsmtp5.bon.at ([195.3.86.187]:59542 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753848Ab1J0Ujv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 16:39:51 -0400
X-Greylist: delayed 1981 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 16:39:50 EDT
From: Markus Grabner <grabner@icg.tugraz.at>
Organization: Graz University of Technology
To: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: staging: line6 driver status
Date: Thu, 27 Oct 2011 22:06:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.7.1; x86_64; ; )
References: <CAJSP0QWV9V7JzCcJROF9_Psib3kC0f67c2OwZzJbxPmZn9SBJg@mail.gmail.com> <20111027090507.GA5213@suse.de> <CAJSP0QWJOODix7xR9JjUsB9XpYinwJ1Mk+GfO9649HGUd92dzQ@mail.gmail.com>
In-Reply-To: <CAJSP0QWJOODix7xR9JjUsB9XpYinwJ1Mk+GfO9649HGUd92dzQ@mail.gmail.com>
Cc: devel@linuxdriverproject.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110272206.26848.grabner@icg.tugraz.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 October 2011 11:43:21 you wrote:
> On Thu, Oct 27, 2011 at 10:05 AM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Oct 27, 2011 at 09:28:59AM +0100, Stefan Hajnoczi wrote:
> >> What is the status of the line6 staging driver?  There is no TODO file
> >> so I'm not sure what is blocking it from leaving staging.
> > 
> > That's a good question.  I don't really know the status of the driver at
> > the moment, does anyone else?
> 
> I have one question about the design of the driver:
> 
> Do we really need the sysfs attributes which boil down to MIDI
> commands?  I think a userspace library provides a better interface
> because the MIDI commands/values vary between device models and bloat
> the driver.  Generic sound recording and MIDI software would talk to
> the driver.  Utilities to control the device could link against the
> userspace library.
> 
> By splitting the code into the kernel MIDI/pcm driver and a userspace
> control library which uses MIDI we can slim down the kernel driver and
> leave the large variation of MIDI commands/values to a library that
> the community can improve for specific device models.
> 
> This will make the driver smaller and easier for review.
I actually already started to work on this, but progress is slow since I'm 
quite busy with other things. As soon as there is a convenient way to access 
device parameters via user space code, I agree that the corresponding sysfs 
attributes should be removed from the driver.

	Kind regards,
		Markus


-- 
Markus Grabner
Institute for Computer Graphics and Vision
Graz University of Technology, Inffeldgasse 16a/II, 8010 Graz, Austria
WWW: http://www.icg.tugraz.at/Members/grabner
