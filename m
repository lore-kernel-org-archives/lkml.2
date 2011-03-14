Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1CNXrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 19:47:55 -0400
Received: from kroah.org ([198.145.64.141]:32860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428Ab1CNXrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 19:47:48 -0400
Date: Mon, 14 Mar 2011 16:25:02 -0700
From: Greg KH <greg@kroah.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH v3] pch_uart: reference clock on CM-iTC
Message-ID: <20110314232502.GA29452@kroah.com>
References: <4D74A600.7070302@compulab.co.il>
 <20110307200733.GA18849@kroah.com>
 <4D761F7F.2030908@compulab.co.il>
 <20110309234238.GA4071@kroah.com>
 <4D78CE98.4040500@compulab.co.il>
 <20110311222529.GA14675@kroah.com>
 <4D7CCB10.50009@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7CCB10.50009@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 03:48:00PM +0200, Denis Turischev wrote:
> Hi Greg,
> 
> There is a patch to pch_phub.c that is absent in your linux/kernel/git/gregkh/tty-2.6.git
> pch_phub: add new device ML7213
> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=c47dda7d179dde17697c3f839f150fecaf6770cb
> 
> >From which repository you want my patch to be based?

Ok, sorry, that was from one of my other trees (the driver-core one).
I've now cherry picked that patch into my tty one and taken yours as
well.

Sorry for the mess, it was my fault.

greg k-h
