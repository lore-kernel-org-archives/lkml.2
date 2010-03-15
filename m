Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937213Ab0COXpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:45:31 -0400
Received: from kroah.org ([198.145.64.141]:45237 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab0COXp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:45:29 -0400
Date: Mon, 15 Mar 2010 16:20:05 -0700
From: Greg KH <greg@kroah.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Peter Feuerer <peter@piie.net>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v2] USB: pl2303: switch to generic write implementation
Message-ID: <20100315232004.GB21339@kroah.com>
References: <201003031608.20277.oliver@neukum.org>
 <1267701172-9549-1-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267701172-9549-1-git-send-email-jhovold@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:12:52PM +0100, Johan Hovold wrote:
> Replace custom fifo-based write implementation with the generic
> kfifo-based one.

What kernel is this patch against?  For some reason it doesn't apply to
my tree right now :(

Care to respin it?

thanks,

greg k-h
