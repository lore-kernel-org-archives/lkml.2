Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1JUNOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 09:14:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab1JUNOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 09:14:22 -0400
Date: Fri, 21 Oct 2011 06:07:52 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: LKML <linux-kernel@vger.kernel.org>, Stable Tree <stable@kernel.org>
Subject: Re: Kernel hard LOCKUP with v3.0.7
Message-ID: <20111021130752.GC8219@suse.de>
References: <4EA1536E.6090001@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA1536E.6090001@profihost.ag>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 01:11:42PM +0200, Stefan Priebe - Profihost AG wrote:
> Hello list,
> 
> today i've seen the following crash using v3.0.7 (renamed to 2.6.40.7).
> 
> http://pastebin.com/raw.php?i=sRq7T4Y0
> 
> I haven't seen this with 3.0.6 but i also changed some kernel config
> options (activated ipv6, changed from SLAB to SLUB).

Any way to reproduce it?

greg k-h
