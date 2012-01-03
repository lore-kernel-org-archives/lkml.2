Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab2ACAii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 19:38:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54009 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2ACAig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 19:38:36 -0500
Date: Tue, 3 Jan 2012 00:38:31 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20120103003831.GB17606@srcf.ucam.org>
References: <20120102215028.GA15701@srcf.ucam.org>
 <CA+55aFz73GuHiOW1NoAuJLea_GKLepiZjrnrgpOKdQizPgnhoA@mail.gmail.com>
 <20120102221235.GA16012@srcf.ucam.org>
 <CA+55aFyHvmvast_kuNddU3iotReR1mOpKM4HGAw80ma8kn+2-g@mail.gmail.com>
 <20120102222920.GA16160@srcf.ucam.org>
 <CA+55aFyUK6X7ip2UXV9iT07=qezXfbw82wn6UKAN8JFQtYNs5Q@mail.gmail.com>
 <20120102230037.GA16458@srcf.ucam.org>
 <4F023E6B.2020307@fastmail.fm>
 <20120103001356.GA17183@srcf.ucam.org>
 <8e95c7e3-e9d5-43c4-8e6a-b8d40584cbd6@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e95c7e3-e9d5-43c4-8e6a-b8d40584cbd6@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 12:22:58AM +0000, Jack Stone wrote:

> So we have a table of USB ids that list the devices that need firmware drivers. When the uvcvideo driver registers the firmware interface with a USB id that matches the list we load the firmware driver and pass it a "warm start" event so it can cache the firmware.
> 
> As long as we can identify the devices that *might* need firmware then we are ok.

We could do all of this. Or we could just push the responsibility for 
this specific case back to userspace, and maybe that's what I should 
have done in the first place.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
