Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970Ab1D2VYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:24:05 -0400
Received: from kroah.org ([198.145.64.141]:47107 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061Ab1D2VYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:24:02 -0400
Date: Fri, 29 Apr 2011 14:23:28 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v3 3/5] Introduce CONFIG_GOOGLE_FIRMWARE
Message-ID: <20110429212328.GA19207@kroah.com>
References: <20110315065839.12047.70666.stgit@mike.mtv.corp.google.com>
 <20110315065855.12047.31930.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315065855.12047.31930.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 11:58:55PM -0700, Mike Waychison wrote:
> In order to keep Google's firmware drivers organized amongst themselves,
> create a new directory for them to live in.  As well, all Google
> firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which defaults
> to 'n' in the kernel build.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

This patch breaks the build:

ld: cannot find drivers/firmware/google/built-in.o: No such file or directory

Care to reoder this to be the last patch in the series?

I've applied the first two, so just send the last 3, with this one being
the last one, and it should be fine.

thanks,

greg k-h
