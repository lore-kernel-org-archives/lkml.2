Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab0KRP7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:59:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab0KRP7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:59:30 -0500
Date: Thu, 18 Nov 2010 07:55:58 -0800
From: Greg KH <gregkh@suse.de>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20101118155558.GA1941@suse.de>
References: <1290085052-4977-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290085052-4977-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 02:57:32PM +0200, Tatyana Brokhman wrote:
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

{sigh}

This changelog entry makes absolutely no sense.  Please write something
that describes what you are doing, and why you are doing it, with full
details (i.e. links to the tests you ran, etc.)  Look at how other
people write their comments for major patches like this, be descriptive
and verbose.  It will help when in 3 years you are asked why this patch
did what it did.

I'm sorry if it feels like I'm picking on you, but I'm trying to help
you get it right for this, and future contributions.

thanks,

greg k-h
