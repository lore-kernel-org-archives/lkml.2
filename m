Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2ACAhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:37:15 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53979 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ACAhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:37:13 -0500
Date: Tue, 3 Jan 2012 00:37:02 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jack Stone <jwjstone@fastmail.fm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103003701.GA17606@srcf.ucam.org>
References: <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
 <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
 <20120102222920.GA16160@srcf.ucam.org>
 <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
 <20120102230037.GA16458@srcf.ucam.org>
 <4F023E6B.2020307@fastmail.fm>
 <20120103001356.GA17183@srcf.ucam.org>
 <20120103002048.75c0104b@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103002048.75c0104b@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 12:20:48AM +0000, Alan Cox wrote:
> > No, the uvcvideo driver would need to call out to load the firmware 
> > loader driver, otherwise you'll never know to load the firmware loader 
> > driver.
> 
> Does that not simply depend which driver has the relevant USB
> identifiers ?

If something presents as a class device then it's going to be picked up 
by the class driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
