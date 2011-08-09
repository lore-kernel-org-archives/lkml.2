Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1HJCCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:02:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab1HJCCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:02:06 -0400
Date: Tue, 9 Aug 2011 13:30:55 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: linux-kernel@vger.kernel.org, pavan_savoy@sify.com
Subject: Re: [PATCH 1/8] drivers:misc: ti-st: avoid a misleading dbg msg
Message-ID: <20110809203055.GA10918@suse.de>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 02:38:53PM -0500, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Previously the private data of each protocol registered to use ST was
> used to determine whether the protocol was registered to use shared
> transport or otherwise.
> However, now a flag is_registered is maintained to identify whether a
> protocol intends to use ST.
> Upon closing of the UART the error message relevant to this lack of
> un-registration was misleading and this patch fixes that.
> 
> Change-Id: I1a452dccd7b4bd53cce923df5b61ce077b7aa466

What is this field for?  It's pretty irrelevant for upstream kernel
work, right?

Please remove.

greg k-h
