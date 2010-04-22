Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab0DVUHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:07:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:59361 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab0DVUHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:07:39 -0400
Date: Thu, 22 Apr 2010 13:07:22 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, 563313@bugs.debian.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [165/197] ACPI: EC: Allow multibyte access to EC
Message-ID: <20100422200722.GA26287@suse.de>
References: <20100422190922.146928687@kvm.kroah.org>
 <alpine.LFD.2.00.1004221257390.26046@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004221257390.26046@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:59:16PM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 22 Apr 2010, Greg KH wrote:
> > 
> > From: Alexey Starikovskiy <astarikovskiy@suse.de>
> > 
> > commit dadf28a10c3eb29421837a2e413ab869ebd upstream
> 
> Hmm. Doesn't this need commit 2060c44576c79086ff24718878d7edaa7384a985
> to fix things up for crazy access_bit_width values?
> 
> Maybe it's there in the series somewhere, but I didn't see it.

Yes, it's two patches later:
	Subject: [167/197] ACPI: EC: Limit burst to 64 bits

good catch.

thanks,

greg k-h
