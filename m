Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595Ab1GEQRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:17:08 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:36708 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754263Ab1GEQRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:17:07 -0400
X-Sasl-enc: 9TreR/qhg76Tprgz1l/qUFlrtpxT9HZu6rPb9yhQh5Vu 1309882626
Date: Tue, 5 Jul 2011 09:15:58 -0700
From: Greg KH <greg@kroah.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        stalin.s@mistralsolutions.com, Greg Kroah-Hartman <gregkh@suse.de>,
        open list <linux-kernel@vger.kernel.org>, m-watkins@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/1] drivers:staging:pruss: add pruss staging mfd
 driver.
Message-ID: <20110705161558.GA26309@kroah.com>
References: <1306827939-4133-1-git-send-email-subhasish@mistralsolutions.com>
 <1306827939-4133-2-git-send-email-subhasish@mistralsolutions.com>
 <20110628210112.GA31081@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628210112.GA31081@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 02:01:12PM -0700, Greg KH wrote:
> On Tue, May 31, 2011 at 01:15:39PM +0530, Subhasish Ghosh wrote:
> > This patch adds the pruss MFD driver and associated include files.
> > For details regarding the PRUSS please refer the folowing link:
> > http://processors.wiki.ti.com/index.php/Programmable_Realtime_Unit_Subsystem
> > 
> > The rational behind the MFD driver being the fact that multiple devices can
> > be implemented on the cores independently. This is determined by the nature
> > of the program which is loaded into the PRU's instruction memory.
> > A device may be de-initialized and another loaded or two different devices
> > can be run simultaneously on the two cores.
> > It's also possible, as in our case, to implement a single device on both
> > the PRU's resulting in improved load sharing.
> > 
> > Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> 
> Please refresh my memory as to why this can't get merged into the
> "normal" part of the kernel?

Dropped from my queue due to lack of response :(

Please resend when you get the chance, and address the above comment in
your changelog entry (and in your TODO file as well.)

thanks,

greg k-h
