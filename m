Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1CNWJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:09:35 -0400
Received: from kroah.org ([198.145.64.141]:45477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1CNWJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:09:34 -0400
Date: Mon, 14 Mar 2011 15:03:13 -0700
From: Greg KH <greg@kroah.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/trivial: Fix common spelling mistakes
Message-ID: <20110314220313.GA21204@kroah.com>
References: <alpine.LNX.2.00.1103141259500.19969@pobox.suse.cz>
 <1300139875-8688-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300139875-8688-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 10:57:55PM +0100, Peter Huewe wrote:
> This patch fixes some very common spelling mistakes in drivers/staging
> The changes were carried out by hand and are made in
> documentation/comments only - no functional change.
> Variables were left untouched on purpose.
> Linebreaks were also left untouched on purpose.
> 
> The fixed spelling mistakes are:
> WRONG -> RIGHT
> 
> accomodate -> accommodate
> acommodate -> accommodate
> 
> adress -> address
> addres -> address
> 
> hightest -> highest
> hight -> height
> hight -> high (when mentioned in contrast to low)
> hightlight -> highlight
> 
> libary -> library
> libaray -> library
> 
> occured -> occurred
> 
> reqest -> request
> reguest -> request
> requst -> request
> reqeust -> request
> 
> acheive -> achieve
> beggining -> beginning
> embarass -> embarrass
> enviroment -> environment
> fagment -> fragment
> indefinately-> indefinitely
> knowlege -> knowledge
> regester -> register
> unferflow -> underflow
> 
> recieve -> receive
> 
> interupt -> interrupt
> interrrupt -> interrupt
> 
> paralell -> parallel
> paralel -> parallel
> preceeding -> preceding
> publically -> publicly
> shedule -> shedule
> supercede -> supersede
> wierd -> weird
> writen -> written
> writting -> writing
> 
> And some other minor changes that caught my eye doing the changes
> 
> KernelVersion: Linux-next of 20110314 (c0ebee1a2)

Unfortunatly, I've applied a bunch of patches since the last linux-next
tree.

It would be nice if I could have taken a bunch of these changes, and if
it was broken up into individual patches (each either doing only one
spelling change, or only operating on one driver/file) then I could
have.  But as it is, I can't :(

So, another reason it makes sense to break patches up into the logical
pieces.  Please do this and resend.

thanks,

greg k-h
