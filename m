Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2AUNs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 08:48:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2AUNsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 08:48:24 -0500
Date: Sat, 21 Jan 2012 08:45:31 -0500
From: Greg KH <gregkh@suse.de>
To: Kashyap Gada <gada.kashyap@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        bringert@android.com, linux-kernel@vger.kernel.org, arve@android.com,
        john.stultz@linaro.org, ccross@android.com
Subject: Re: [PATCH 4/4] Staging: android: Fix struct definitioni warning
 from static to const
Message-ID: <20120121134530.GA21457@suse.de>
References: <1327112269-17530-1-git-send-email-gada.kashyap@gmail.com>
 <20120121080838.GK3294@mwanda>
 <20120121125314.GC18829@suse.de>
 <CANJXcUaxX8kTArQ3tL4hHnOVAq=yLzLjfMe1CbSi-n-UcW6dEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANJXcUaxX8kTArQ3tL4hHnOVAq=yLzLjfMe1CbSi-n-UcW6dEw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sat, Jan 21, 2012 at 01:19:51PM +0000, Kashyap Gada wrote:
> Greg Im just following your tutorials and when i check the mail im sending in
> terminal it comes proper but when i see the mail what was sent by git
> send-email it doest have any of these. How to ensure proper patch numbers.

Send them all at once.

Also, you forgot the patch description and the signed-off-by, which I
know is mentioned in the tutorial.  Please read the file,
Documentation/SubmittingPatches please.

thanks,

greg k-h
