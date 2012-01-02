Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2ABDdk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 22:33:40 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39979 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2ABDdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 22:33:37 -0500
Date: Mon, 2 Jan 2012 03:33:20 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Oliver Neukum <oliver@neukum.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120102033320.GA6184@srcf.ucam.org>
References: <201201011322.34483.oliver@neukum.org>
 <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
 <CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com>
 <201201012227.56568.oliver@neukum.org>
 <20120101223913.3ff57d0f@milhouse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120101223913.3ff57d0f@milhouse>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 01, 2012 at 10:39:13PM +0100, Michael Büsch wrote:

> I don't get it. Why would a device enter a state after resume, that it was not
> in at _any_ time before the machine was suspended?

Load firmware. Do a warm reboot. The hardware may maintain the 
initialised state, but the new kernel will never have loaded it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
