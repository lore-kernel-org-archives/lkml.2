Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab2ADCoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:44:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56487 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2ADCoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:44:21 -0500
Date: Tue, 3 Jan 2012 16:36:44 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/7] amp/remoteproc: add debugfs entries
Message-ID: <20120103233644.GD2492@ponder.secretlab.ca>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <1319536106-25802-3-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319536106-25802-3-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:48:21AM +0200, Ohad Ben-Cohen wrote:
> Expose several remote processor properties (name, state, trace buffer)
> that are helpful for debugging.
> 
> This part is extracted to a separate patch just to keep the review load
> down.
> 
> Designed with Brian Swetland <swetland@google.com>.
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> ---
>  drivers/amp/remoteproc/Makefile             |    1 +
>  drivers/amp/remoteproc/remoteproc_debugfs.c |  182 +++++++++++++++++++++++++++
>  2 files changed, 183 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/amp/remoteproc/remoteproc_debugfs.c
