Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1DYV3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:29:22 -0400
Received: from 1wt.eu ([62.212.114.60]:34809 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab1DYV3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:29:20 -0400
Date: Mon, 25 Apr 2011 23:29:10 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kernel development list <linux-kernel@vger.kernel.org>, stable@kernel.org,
        stable-review@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 039/173] OHCI: work around for nVidia shutdown problem
Message-ID: <20110425212910.GC7646@1wt.eu>
References: <20110425200234.685881927@pcw.home.local> <Pine.LNX.4.44L0.1104251722470.1741-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1104251722470.1741-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 05:24:34PM -0400, Alan Stern wrote:
(...)
> Some people have reported that more recent Nvidia systems work
> correctly without this patch and have problems when the patch is
> applied.  For now, I suggest omitting this patch.

Done, thank you Alan !

Willy

