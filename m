Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab0EQPiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:38:14 -0400
Received: from kroah.org ([198.145.64.141]:47865 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0EQPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:38:13 -0400
Date: Mon, 17 May 2010 08:35:38 -0700
From: Greg KH <greg@kroah.com>
To: Nils Radtke <lkml@Think-Future.de>
Cc: Matthias Urlichs <smurf@smurf.noris.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       stable@kernel.org
Subject: Re: [2.6.34 PATCH] USB: option.c: OLIVETTI OLICARD100 support
Message-ID: <20100517153537.GA28358@kroah.com>
References: <20100517121411.GA21483@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100517121411.GA21483@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 02:14:11PM +0200, Nils Radtke wrote:
> From: Nils Radtke <lkml@Think-Future.de>
> 
> This patch adds support for an olivetti olicard100 HЅDPA usb-stick.
> 
> This device is a zeroCD one with ID 0b3c:c700 that needs switching via 
> eject or usb-modeswitch with 
> MessageContent="5553424312345678000000000000061b000000030000000000000000000000".
> After switching it has ID 0b3c:c000 and provides 5 serial ports ttyUSB[0-4].
> Port 0 (modem) and 4 are interrupt ports.
> 
> Signed-off-by: Nils Radtke <lkml@Think-Future.de>
> 
> ---
> 
> I guess the previous patch for .33.4 came to late for inclusion. Am I missing
> something else to get the IDs merged into .35 or maybe .34.1?

No, just that you need to be a bit more patient, you only send your
first patch on Saturday, give me a chance to get to it...

thanks,

greg k-h
