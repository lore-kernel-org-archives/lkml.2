Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2EOOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2EOOx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:53:27 -0400
Date: Tue, 15 May 2012 17:53:16 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515145316.GF6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
 <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
 <20120515150015.5bf17aea@pyramind.ukuu.org.uk>
 <20120515143644.GD6948@redhat.com>
 <20120515155206.520e46b6@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515155206.520e46b6@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 03:52:06PM +0100, Alan Cox wrote:
> > It is easy to be confused since there are two EDD 3 specs. First is from
> > Phoenix BIOS (linked at the first mail of the thread) and it does not have
> > enough info even for ATA. You can't tell primary ATA controller from secondary.
> 
> Yes you can - it's defined by the PCI specification for compatibility
How? ATA device path has only Master/Slave. Interface path has only
bus/slot/function. So given all that in int13_80 how do I know if this
is primary or secondary controller?

T13 added has Channel number in Interface path.

> mappings on hardware of that era. Once you move to newer systems with ATA
> native PCI controllers then you need the 3.0 spec not the Phoenix spec.
> 
> Alan

--
			Gleb.
