Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2LWXYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:24:39 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52290 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2LWXYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:24:37 -0500
Date: Sun, 23 Dec 2012 15:27:48 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Woody Suwalski <terraluna977@gmail.com>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.8-rc1 - another regression on USB :-(
Message-ID: <20121223232748.GA23804@kroah.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
 <50D764BA.1030501@gmail.com>
 <CA+55aFwButY7LcOH2XCh1Q8fKi2KQiNS_Caj4O9cHzb4C=TKGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwButY7LcOH2XCh1Q8fKi2KQiNS_Caj4O9cHzb4C=TKGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2012 at 02:35:49PM -0800, Linus Torvalds wrote:
> Woody,
>  Any chance you can bisect this? It's not going to be hugely pleasant
> (with 11k+ commits in between 3.7 and 3.8-rc1 you'll have to compile
> and test at least 14 kernels), but it would help enormously. Of
> course, maybe some USB person can guess what would cause the device to
> go offline..
> 
> Added Greg and the linux-usb mailing list to the participants list:
> the images are in the original email on lkml, but there isn't anything
> particularly interesting there, it really just seems to be an
> unexpected and spurious USB disconnect, resulting in "USB disconnect,
> device number 2" followed by "Rejecting I/O to offline device".

I don't see any images on lkml, sorry.

The kernel log for when the disconnect happened would be great to get.

The kernel can't cause a device to disconnect, that's an electrical
thing usually, is this perchance a flaky device/connection?  Or has it
always worked on older kernels?

What host controller is being used here (xhci, ehci, etc.?)

thanks,

greg k-h
