Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1K0VEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 16:04:08 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44262 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab1K0VEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 16:04:07 -0500
X-Sasl-enc: +ADa+t0sOews1ulnPPH4yUZpD+LJEm/K3H6+bn2JJfQS 1322427844
Date: Mon, 28 Nov 2011 06:03:56 +0900
From: Greg KH <greg@kroah.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: matthieu castet <castet.matthieu@free.fr>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: re : 3.2-rc2 regression due to commit "USB: EHCI: fix HUB TT
 scheduling issue with iso transfer" 811c926c
Message-ID: <20111127210356.GA8493@kroah.com>
References: <20111126231304.0bf12f69@mat-laptop>
 <242709247.20111127210813@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <242709247.20111127210813@eikelenboom.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 09:08:13PM +0100, Sander Eikelenboom wrote:
> Hi Matthieu,
> 
> I can confirm this patch fixes my problem, after testing haven't seen any problems yet.

Wonderful, thanks for testing.

Matthieu, care to make this up into a "real" patch so that I can apply
it and get it into 3.2?

thanks,

greg k-h
