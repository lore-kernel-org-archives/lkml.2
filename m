Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511Ab0J2AuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 20:50:11 -0400
Received: from kroah.org ([198.145.64.141]:51821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756446Ab0J2AuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 20:50:07 -0400
Date: Thu, 28 Oct 2010 17:50:09 -0700
From: Greg KH <greg@kroah.com>
To: Konstantin Katuev <kkatuev@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/keucr driver - uninitialized variable & proper
	memset length
Message-ID: <20101029005009.GA8142@kroah.com>
References: <AANLkTimvLvtLDLiYT2geZ3Qh1+cugjB-OYQcGv9hhGVG@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimvLvtLDLiYT2geZ3Qh1+cugjB-OYQcGv9hhGVG@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:20:33PM +1100, Konstantin Katuev wrote:
> There was commented out transfer_flags initialization.
> And i think memset should fill entire structure, not only length of
> pointer to it.
> Driver now works.

Great!

> 
> Konstantin

Oops, I need a "Signed-off-by:" line in order to be able to apply this.
Read Documentation/SubmittingPatches for more details about this?

Care to resend it with that and cc: me so I make sure to see it so that
I can apply it?

thanks,

greg k-h
