Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0LHQDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 11:03:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab0LHQDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 11:03:16 -0500
Date: Wed, 8 Dec 2010 08:01:49 -0800
From: Greg KH <gregkh@suse.de>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
Message-ID: <20101208160149.GA10313@suse.de>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
 <20101207162755.GA32328@suse.de>
 <alpine.LFD.2.02.1012071814160.1998@localhost6.localdomain6>
 <20101207183305.GA21802@suse.de>
 <alpine.LFD.2.02.1012081115250.1909@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1012081115250.1909@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 11:16:46AM +0100, Sebastian Ott wrote:
> Ok, understood. The sad part is, that virtually all s390 device drivers
> do this.

Then they are broken, please fix them :)

> I've not checked the archives, but i guess this is the status
> since the 2.6 release. I don't think that changing all those drivers (not
> to mention userspace relying on the structure) is an option here.

Not true, there's really not that many s390 drivers, just fix them to do
the correct thing here, no userspace needs to be changed at all.

thanks,

greg k-h
