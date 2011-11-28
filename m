Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1K1XwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 18:52:00 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58581 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395Ab1K1Xv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 18:51:59 -0500
X-Sasl-enc: TrM4Zm5BUDTB3Us9ncJxQMiWIQ/K+XGWvHeeef9mSiRe 1322524318
Date: Tue, 29 Nov 2011 08:50:52 +0900
From: Greg KH <greg@kroah.com>
To: Dmitry Nezhevenko <dion@inhex.net>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
Subject: Re: Linux 3.1.3
Message-ID: <20111128235052.GA21975@kroah.com>
References: <20111127190735.GA11899@kroah.com>
 <20111128173708.GA3785@laptop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128173708.GA3785@laptop.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 07:37:09PM +0200, Dmitry Nezhevenko wrote:
> On Mon, Nov 28, 2011 at 04:07:35AM +0900, Greg KH wrote:
> > I'm announcing the release of the 3.1.3 kernel.
> > 
> > All users of the 3.1 kernel series must upgrade.
> > 
> 
> I don't know where to report this, since bugzilla is still down. This
> upgrade breaks UVC webcam that I've:
> 
> Bus 002 Device 002: ID 04f2:b029 Chicony Electronics Co., Ltd 1.3M UVC
> Webcam
> 
> I'm getting followed while trying to capture from it:
> 
> 	[  187.555352] uvcvideo: Failed to submit URB 0 (-28).
> 
> Kernel 3.1.2 is definitely working.

Now fixed in 3.1.4, sorry about that.

greg k-h
