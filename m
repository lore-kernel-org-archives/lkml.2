Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2AQPRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:17:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51129 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754306Ab2AQPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:17:31 -0500
X-Sasl-enc: bpNjVw9SuWB2WUtC65cTYmUqq7VbUoUw3ETY3DxSXL+V 1326813450
Date: Tue, 17 Jan 2012 07:14:23 -0800
From: Greg KH <greg@kroah.com>
To: Praveen kumar <chatpravi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Subject: Re: USB controller status
Message-ID: <20120117151423.GA11094@kroah.com>
References: <CAOzqYK6+6ML=HqYOk_gJaAzB=5v_wDEzMs7C_YDgMHmB2LtWHw@mail.gmail.com>
 <20120116173726.GA18147@kroah.com>
 <CAOzqYK5-W8L8oDwY4iF8kpGAxLOiVTu2vA20sEvzBtkrTk79-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOzqYK5-W8L8oDwY4iF8kpGAxLOiVTu2vA20sEvzBtkrTk79-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 07:26:24PM +0530, Praveen kumar wrote:
> Hi Greg,
> 
> What type of diagnostics are you trying to do?
>            I am trying to is to make communication to all the chips present on
> board (from kernel) and make sure all the input/output lines are working on
> that chip and the status of the configuration.
> As I am doing with the other chips like video controller ,audio controller etc
> ,I want to make sure the working condition of the USB controller and some tests
> to prove input and output lines are working and if possible loop back data
> test.

Good luck with that, it might be hard to do from within the kernel :)

> How can it not be configured correctly?
> 
> I am not sure in which condition the configuration of controller may fail but
> just I want to make sure the controller is configured properly.
> 
> You have looked at the debugfs files for the usb controllers for this
> type of thing already, right?
> 
> I have seen debugfs where I can dump all the configuration reg values ,but not
> sure to see which reg values to confirm  controller is configured properly.
> 
> Also I was trying to get the linux-usb project (http://sourceforge.net/apps/
> trac/sourceforge/wiki/Git) through git to make use of some code in there for
> some of the tests but I am not able to get it.
> Is there any alternative link from where I can get the code (like lsusb.c etc
> )..

usbutils are on github, look in your distro for the location of the
source.

greg k-h
