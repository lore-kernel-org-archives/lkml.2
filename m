Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762687Ab2FVTib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:38:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53836 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762670Ab2FVTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:38:28 -0400
Date: Fri, 22 Jun 2012 12:38:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, lwn@lwn.net,
        Willy Tarreau <w@1wt.eu>, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.32.55
Message-ID: <20120622193824.GA3371@kroah.com>
References: <20120125223434.GA31647@kroah.com>
 <4FE4C1A3.4080804@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE4C1A3.4080804@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 09:04:03PM +0200, Jiri Slaby wrote:
> On 01/25/2012 11:34 PM, Greg KH wrote:
> > I'm announcing the release of the 2.6.32.55 kernel.
> ...
> > Bjorn Helgaas (1): PNP: work around Dell 1536/1546 BIOS MMCONFIG
> > bug that breaks USB
> 
> Hi, this one is dependant on 24d25dbfa63c3 (x86/PCI: amd: factor out
> MMCONFIG discovery), otherwise amd_get_mmconfig_range is undefined...

Interesting that this was reported almost 6 months after it was released :)

Anyway, I'm no longer handling 2.6.32 kernel stuff anymore, so there's
nothing I can do here, sorry.

greg k-h
