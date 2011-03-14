Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1CNPvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:51:13 -0400
Received: from kroah.org ([198.145.64.141]:50405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab1CNPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:49:55 -0400
Date: Mon, 14 Mar 2011 08:43:17 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 08/12] x86: get_bios_ebda_length()
Message-ID: <20110314154317.GC31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014337.6133.19636.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312014337.6133.19636.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 05:43:37PM -0800, Mike Waychison wrote:
> Add a wrapper routine that tells us the length of the EBDA if it is
> present.  This guy also ensures that the returned length doesn't let the
> EBDA run past the 640KiB mark.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  arch/x86/include/asm/bios_ebda.h |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)

Any objections from the x86 developers about me including this with the
other efi patches in my driver-core-next tree?

thanks,

greg k-h
