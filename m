Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab0DFNar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:30:47 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:52926 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755908Ab0DFNal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:30:41 -0400
Date: Tue, 6 Apr 2010 15:30:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Philippe Troin <phil@fifi.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
Message-ID: <20100406133033.GB1424@ucw.cz>
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com> <201003310125.26266.laurent.pinchart@ideasonboard.com> <v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com> <20100401165606.GA1677@ucw.cz> <87aatn9k7j.fsf@old-tantale.fifi.org> <20100404132223.GA1346@ucw.cz> <87ljd3ujrp.fsf@old-tantale.fifi.org> <20100404193405.GA15065@elf.ucw.cz> <r2m45cc95261004060232y4c862040r9044bb435ad7eae5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2m45cc95261004060232y4c862040r9044bb435ad7eae5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2010-04-06 11:32:46, Mohamed Ikbel Boulabiar wrote:
> Hi !
> 
> > Ok, that puts the problem firmly into uvcvideo area.
> >
> > Try changing its _resume routine to whatever is done on device
> > unplug... it should be rather easy, and is quite close to "correct"
> > solution.
> 
> I am waiting to try that.
> 
> If I always need to rmmod/modprobe everytime, that is meaning that
> something is kept messed somewhere in memory and should be cleaned by
> restart (reinitialize ?) the device.

Yes. And it also means that problem is within the stuff being rmmoded/insmoded.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
