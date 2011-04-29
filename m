Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab1D2Uoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:44:32 -0400
Received: from kroah.org ([198.145.64.141]:46893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933816Ab1D2Uob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:44:31 -0400
Date: Fri, 29 Apr 2011 13:42:24 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v3 1/5] x86: get_bios_ebda_length()
Message-ID: <20110429204224.GA16444@kroah.com>
References: <20110315065839.12047.70666.stgit@mike.mtv.corp.google.com>
 <20110315065844.12047.54555.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315065844.12047.54555.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:58:45PM -0700, Mike Waychison wrote:
> Add a wrapper routine that tells us the length of the EBDA if it is
> present.  This guy also ensures that the returned length doesn't let the
> EBDA run past the 640KiB mark.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  arch/x86/include/asm/bios_ebda.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)

Ok, due to a total lack of response from the x86 maintainers, I'm going
to take this through my driver-core tree as I have no objection to it
and Mike's been very patient for a while now...

thanks,

greg k-h
