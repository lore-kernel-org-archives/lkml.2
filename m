Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0D1RuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:50:07 -0400
Received: from kroah.org ([198.145.64.141]:54608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0D1RuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:50:05 -0400
Date: Wed, 28 Apr 2010 10:39:39 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rt28xx: Make PCI_{MAP,UNMAP}_SINGLE type-safe
Message-ID: <20100428173939.GA18634@kroah.com>
References: <alpine.DEB.2.00.1003282040480.4731@ernie.pinecrest>
 <1269821357.8653.231.camel@localhost>
 <1269822285.8653.251.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269822285.8653.251.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 01:24:45AM +0100, Ben Hutchings wrote:
> To avoid recurrence of bugs such as <http://bugs.debian.org/575726>,
> change the type of the first parameter to linux_pci_{map,unmap}_single()
> from void * to struct rt_rtmp_adapter *.  Also do not define the macros
> PCI_{MAP,UNMAP}_SINGLE() when building the rt2870sta driver; they are
> not used and if they were that would be a bug.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk> 

In the future, please do not sign your emails, it just makes it harder
to apply them :(

thanks,

greg k-h
