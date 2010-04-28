Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab0D1XIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 19:08:21 -0400
Received: from kroah.org ([198.145.64.141]:51654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab0D1XIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 19:08:19 -0400
Date: Wed, 28 Apr 2010 15:56:56 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, gregkh@suse.de, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
Message-ID: <20100428225656.GE24604@kroah.com>
References: <1268927857-14141-1-git-send-email-lindley@coyote.org>
 <4BA254BC.6090507@cs.helsinki.fi>
 <4BA2A68D.9050401@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2A68D.9050401@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 11:17:49PM +0100, Lars Lindley wrote:
> On 2010-03-18 17:28, Pekka Enberg wrote:
> > Lars Lindley wrote:
> >> I fixed all problems found by checkpatch.pl and removed CamelCase
> >> from argument names.
> ..snip..
> >> +void MLME_GetNextPacket(struct wbsoft_priv *adapter,
> >> +            struct wb35_descriptor *pdes);
> > 
> > Can we get rid of the "p" prefix (hungarian notation) while at it?
> > 
> Sure..
> I changed pdes to des, pmmpdu to mmpdu and widx to idx.
> Looks all right?
> 
> /Lars
> 
> 
> 
> Here is the new patch against master:
> 
> [PATCH] staging: winbond: mlmetxrx_f.h Coding style fixes.
> 
> I fixed all problems found by checkpatch.pl and removed CamelCase
> and hungarian notation from the argument names.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>

This one didn't apply for some reason :(

Care to redo it against linux-next tomorrow?

thanks,

greg k-h
