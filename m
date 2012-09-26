Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2IZUa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:30:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49032 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2IZUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:30:25 -0400
Date: Wed, 26 Sep 2012 13:30:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Poddar, Sourav" <sourav.poddar@ti.com>
Cc: alan@linux.intel.com, tony@atomide.com, khilman@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, balbi@ti.com, paul@pwsan.com
Subject: Re: [RFT/PATCH] serial: omap: prevent resume if device is not
 suspended.
Message-ID: <20120926203020.GA18291@kroah.com>
References: <1347972050-3509-1-git-send-email-sourav.poddar@ti.com>
 <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKdam572krJZcayRdJ_AciCUZH3LuzD9yoHenhxrB6j9xDZ6JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:52:03PM +0530, Poddar, Sourav wrote:
> Hi Greg,
> 
> Ping on this?

It was a RFT patch, with a huge thread.  What's the resolution here?
Did people figure out the real problem here or not?  If so, care to
resend the proper patch so I know what to apply?

thanks,

greg k-h
