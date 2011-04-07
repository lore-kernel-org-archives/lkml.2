Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1DGWsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:48:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756293Ab1DGWsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:48:35 -0400
Date: Thu, 7 Apr 2011 15:46:29 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: hjanssen@microsoft.com, kys@microsoft.com, v-abkane@microsoft.com,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Olaf Hering <olaf@aepfle.de>,
        stable <stable@kernel.org>
Subject: Re: [PATCH] staging: hv: use sync_bitops when interacting with the
 hypervisor
Message-ID: <20110407224629.GA28700@suse.de>
References: <1302216598-686-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302216598-686-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 03:49:58PM -0700, Haiyang Zhang wrote:
> From: Olaf Hering <olaf@aepfle.de>
> 
> Locking is required when tweaking bits located in a shared page, use the
> sync_ version of bitops. Without this change vmbus_on_event() will miss
> events and as a result, vmbus_isr() will not schedule the receive tasklet.
> 
> Backported to 2.6.32 stable kernel by Haiyang Zhang <haiyangz@microsoft.com>

Thanks for the backport, now queued up.

greg k-h
