Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1CNPt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:49:57 -0400
Received: from kroah.org ([198.145.64.141]:50412 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1CNPt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:49:56 -0400
Date: Mon, 14 Mar 2011 08:43:54 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v2 09/12] x86: Better comments for get_bios_ebda()
Message-ID: <20110314154354.GD31340@kroah.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
 <20110312014342.6133.61993.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110312014342.6133.61993.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 05:43:42PM -0800, Mike Waychison wrote:
> Make the comments a bit clearer for get_bios_ebda so that it actually
> tells us what it is returning.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  arch/x86/include/asm/bios_ebda.h |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)

Any objection/acks from the x86 maintainers about me including this in
the driver-core-next tree along with the other efi patches?

thanks,

greg k-h
