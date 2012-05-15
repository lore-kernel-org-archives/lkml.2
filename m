Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab2EOOMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab2EOOM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:12:28 -0400
Date: Tue, 15 May 2012 17:12:14 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515141214.GB6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
 <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
 <20120515144945.339e742f@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515144945.339e742f@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 02:49:45PM +0100, Alan Cox wrote:
> > I do not see support for other spec to be important, but you are welcome
> > to write support for it if you need it. The only way I see to check what
> > spec edd info corresponds to is to calculate checksum according to both
> > specs and see which one succeeds.
> 
> No it doesn't work like that. This is a regression for existing working
> systems. It needs to be reverted or fixed. If it was a new feature you'd
> have a point - but it isn't. You've broken stuff, undo the breakage.
> 
Code never supported anything but EDD4.0 spec. I checked history git.
Code erroneously tried to interpret EDD3.0 info according to EDD4.0 spec
providing garbage as a result.

--
			Gleb.
