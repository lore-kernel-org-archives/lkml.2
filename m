Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2EEO5h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:57:37 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:62920 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2EEO5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:57:35 -0400
Date: Sat, 5 May 2012 07:57:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120505145732.GA27577@kroah.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
 <20120503213456.77c55c51@pyramind.ukuu.org.uk>
 <20120505003208.GA30718@kroah.com>
 <20120505120137.11a45c86@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120505120137.11a45c86@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 12:01:37PM +0100, Alan Cox wrote:
> > Will the new ldisc mess with the tty stuff to prevent "normal" serial
> > data and line settings from being handled properly?  If not, that all
> > looks very good to me, thanks for working this out.
> 
> It'll have no effect on that. What it will do is provide a way for things
> like ISO7816 ldiscs to use the extra pins (as they can call from the
> ldisc into the gpio layer) and to know the mapping of the extra control
> wires, which varies by device.

Ok, that sounds good to me.
