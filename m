Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2FKVOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 17:14:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47855 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2FKVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 17:14:32 -0400
Date: Mon, 11 Jun 2012 14:14:28 -0700
From: gregkh <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alex Shi <alex.shi@intel.com>, "Sharp, Sarah A" <sarah.a.sharp@intel.com>,
        Alan stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20120611211428.GB24904@kroah.com>
References: <1331787186.2979.71.camel@debian>
 <20120315145743.GA7928@kroah.com>
 <4F6204B7.5010908@intel.com>
 <20120315175608.GA6077@xanatos>
 <4FC5D04E.5040907@intel.com>
 <4FD59AD8.1050109@intel.com>
 <20120611204709.GC5742@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611204709.GC5742@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 01:47:09PM -0700, Sarah Sharp wrote:
> Hi Alex,
> 
> This got lost in the 3.5 push, but I think it's a good candidate for
> 3.6.  I think Greg is accepting 3.6 patches now, and I'll send this off
> to him.

Yes, I am taking 3.6 stuff now.  In the future, once -rc1 is out, I can
take patches for the next release at that point in time.

greg k-h
