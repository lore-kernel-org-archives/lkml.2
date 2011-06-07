Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1FGNfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:35:06 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:34725 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab1FGNfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:35:05 -0400
X-Sasl-enc: fOe7DMLLNIfnaBCuIJ/zta1kjePj3FnsDB0sB2TxZU3g 1307453703
Date: Tue, 7 Jun 2011 06:34:02 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Antony Pavlov <antony@niisi.msk.ru>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] 8250_pci: Fix build warning
Message-ID: <20110607133402.GA15743@kroah.com>
References: <1306749174-31216-1-git-send-email-bp@alien8.de>
 <20110607072617.GB21263@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607072617.GB21263@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 09:26:17AM +0200, Borislav Petkov wrote:
> Hey Greg,
> 
> can you please pick this one up - warning is still present in -rc2 so it
> looks like no one else fixed it yet :).

Sorry, bad jet-lag at the moment, I have it in my "to-apply" queue,
along with about 8 different copies of it from different people, and
I'll get to it in a short while.

greg k-h
