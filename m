Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1FITW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:22:57 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37014 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175Ab1FITWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:22:53 -0400
X-Sasl-enc: Qb+ovftE6V2xdl5RxX1m6kifqpI71A4qoxmKUdSB/a1q 1307647372
Date: Thu, 9 Jun 2011 12:22:43 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, brudley@broadcom.com,
        henryp@broadcom.com, rvossen@broadcom.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 related)
Message-ID: <20110609192243.GA3980@kroah.com>
References: <20110609172745.dfd3a298.sfr@canb.auug.org.au>
 <20110609184127.GA2760@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110609184127.GA2760@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 11:41:27AM -0700, Greg KH wrote:
> > Also in several other files in drivers/staging/brcm80211/
> > 
> > Also:
> > 
> > drivers/staging/comedi/drivers.c: In function 'comedi_buf_alloc':
> > drivers/staging/comedi/drivers.c:505:37: error: 'PAGE_KERNEL_NOCACHE' undeclared (first use in this function)
> > In file included from drivers/staging/comedi/drivers/addi_apci_035.c:7:0:
> > drivers/staging/comedi/drivers/addi-data/addi_common.c: In function 'i_ADDI_Attach':
> > drivers/staging/comedi/drivers/addi-data/addi_common.c:2765:7: error: implicit declaration of function 'virt_to_bus'
> > 
> > (Also several other occurrences of that one)
> 
> I'll fix this up, it looks just like a #include that needs to be added.

I've fixed all of these up, thanks for reporting them.

greg k-h
