Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227Ab0JRUC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:02:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35290 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257Ab0JRUC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:02:56 -0400
Date: Mon, 18 Oct 2010 22:02:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Paulo Marques <pmarques@grupopie.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 0/3] Use kasprintf
In-Reply-To: <4CBC8D4E.90008@grupopie.com>
Message-ID: <Pine.LNX.4.64.1010182202260.22877@ask.diku.dk>
References: <1287341311-11161-1-git-send-email-julia@diku.dk>
 <4CBC8D4E.90008@grupopie.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Paulo Marques wrote:

> Julia Lawall wrote:
> > These patches convert a sequence of kmalloc and memcpy to use kasprintf
> > instead.
> 
> Aren't these patches just a more convoluted way of doing a kstrdup?
> 
> I would imagine that a kasprintf would make more sense when the format
> string is more complex than "%s", or am I missing something?

They have all already been changed to either kmemdup or kstrdup.

thanks,
julia
