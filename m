Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1DSX4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:56:45 -0400
Received: from kroah.org ([198.145.64.141]:40904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab1DSX4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:56:44 -0400
Date: Tue, 19 Apr 2011 16:50:55 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v3 1/5] x86: get_bios_ebda_length()
Message-ID: <20110419235055.GA11701@kroah.com>
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

Again, x86 maintainers, any ack/nak for this and the second patch in
this series?  Any objection for me queueing this up through the
driver-core tree so I can take the follow-on patches in this series?

thanks,

greg k-h
