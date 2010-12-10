Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab0LJSTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:19:32 -0500
Received: from kroah.org ([198.145.64.141]:35326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab0LJSTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:19:31 -0500
Date: Fri, 10 Dec 2010 10:16:30 -0800
From: Greg KH <greg@kroah.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl, gregkh@suse.de,
        mchehab@redhat.com
Subject: Re: [stable] [RESEND][PATCH for stable 2.6.36 REGRESSION] cx25840:
 Prevent device probe failure due to volume control ERANGE error]
Message-ID: <20101210181630.GA12772@kroah.com>
References: <1291987197.2064.8.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291987197.2064.8.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 08:19:57AM -0500, Andy Walls wrote:
> Resending, since this didn't appear to make its way into in 2.6.36.2.

That's because it's not in Linus's tree, right?  I have to wait for that
to happen before I can add it to a stable tree.

thanks,

greg k-h
