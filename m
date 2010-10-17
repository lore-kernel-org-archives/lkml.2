Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab0JQSpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 14:45:01 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57295 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502Ab0JQSpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 14:45:00 -0400
Date: Sun, 17 Oct 2010 20:44:58 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/staging: Return -ENOMEM on memory allocation
 failure
In-Reply-To: <Pine.LNX.4.64.1010152157440.29421@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1010172043320.394@ask.diku.dk>
References: <1287147610-8041-2-git-send-email-julia@diku.dk> <4CB86431.5000305@bfs.de>
 <Pine.LNX.4.64.1010152157440.29421@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010, Julia Lawall wrote:

> On Fri, 15 Oct 2010, walter harms wrote:
> 
> > This looks like a case for kasprintf().
> 
> OK, I will take a look at it.

Instead, I have found some other occurrences of kmalloc + memcpy that 
could be kasprintf, so I have done them all in another patch series, with 
the subject "Use kasprintf".

julia
