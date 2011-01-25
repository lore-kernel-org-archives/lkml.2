Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1AYCx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:53:27 -0500
Received: from kroah.org ([198.145.64.141]:41880 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1AYCx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:53:26 -0500
Date: Tue, 25 Jan 2011 10:06:58 +0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 1/6] Add oops notification chain.
Message-ID: <20110125020658.GA3481@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125002439.12637.8515.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 04:24:39PM -0800, Mike Waychison wrote:
> From: Aaron Durbin <adurbin@google.com>
> 
> Later firmware patches in this series would like to be able to be
> notified whenever an oops occurs on the system, so that it can be
> recorded in the boot log.
> 
> This patch introduces a notifier_block called "oops_notifier_list"
> so that drivers can register to get called whenever an Oops is
> triggered.

But we already have a panic notifier list.  Why create a new one?
What's wrong with the existing one that doesn't work properly for you?

thanks,

greg k-h
