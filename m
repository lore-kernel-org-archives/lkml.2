Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab1GDQcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:32:04 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35155 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758328Ab1GDQcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:32:03 -0400
X-Sasl-enc: lSiXJ6cVKxPA+2rc4GvawpX+9vysDW8nxz352uNW+p66 1309797121
Date: Mon, 4 Jul 2011 09:31:50 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB console broken in -next ?
Message-ID: <20110704163150.GA18935@kroah.com>
References: <20110704171959.0aa2cafa@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704171959.0aa2cafa@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 05:19:59PM +0100, Alan Cox wrote:
> I'm seeing the USB console hang part way through the boot up. It looks as
> if it hangs the box solid about the point the standard USB setup/binding
> would occur for the serial driver it is using in console mode
> 
> Any ideas - not sure how old the problem is as I've not needed USB
> console for a long time.

No ideas, sorry, but I haven't tried a USB console out in a long time
either.

greg k-h
