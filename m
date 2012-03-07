Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2CGGBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:01:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36423 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab2CGGBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:01:02 -0500
X-Sasl-enc: 1OkNLgZFXiI6BMPyydAEnLskJB5NFCbSCQetOg/+j8OX 1331099907
Date: Tue, 6 Mar 2012 21:50:55 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: triage for March 6, 2012
Message-ID: <20120307055055.GA8193@kroah.com>
References: <20120307024306.GA18493@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307024306.GA18493@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 09:43:07PM -0500, Paul Gortmaker wrote:
> 
> sparc:allmodconfig
> 	when:	Mar 2, 17:53
> 	why:	drivers/usb/gadget/pch_udc.c: implicit declaration of function 'irq_set_irq_type'
> 	status:	reported by PaulG, WIP by Tomoya MORINAGA 
> 	fix:	
> 	ref:	http://comments.gmane.org/gmane.linux.kernel.next/21060
> ------------------
> 
> sparc64:allmodconfig
> 	when:	Mar 2, 18:51
> 	why:	drivers/usb/gadget/pch_udc.c: implicit declaration of function 'irq_set_irq_type'
> 	status:	reported by PaulG, WIP by Tomoya MORINAGA 
> 	fix:	
> 	ref:	http://comments.gmane.org/gmane.linux.kernel.next/21060

These should both be fixed now, in the next linux-next release, if not,
please let me know.

thanks,

greg k-h
