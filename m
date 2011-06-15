Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830Ab1FOPfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 11:35:54 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:35953 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab1FOPfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 11:35:53 -0400
Date: Wed, 15 Jun 2011 17:35:47 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <greg@farmergreg.com>
Cc: linux-kernel@vger.kernel.org, cocci@diku.dk, Gilles.Muller@lip6.fr
Subject: Re: [Cocci] Re: [PATCH v2] coccinelle: if (ret) return ret; return
 ret; semantic patch
In-Reply-To: <4DF8D0B4.7020505@gregd.org>
Message-ID: <Pine.LNX.4.64.1106151735020.10106@ask.diku.dk>
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
 <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk> <4DF67933.9080707@cuw.edu>
 <Pine.LNX.4.64.1106140746590.14970@ask.diku.dk> <4DF7D197.5070205@cuw.edu>
 <4DF807B4.8010807@gregd.org> <Pine.LNX.4.64.1106150751390.27735@ask.diku.dk>
 <4DF8D0B4.7020505@gregd.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> except that 4 of the 5 ORs are cases where we want to do the -return ret; +
> return ret; So I suppose for performance, I should actually add the +/- to
> each of the 4 cases that we want cocci to generate a patch for?

Actually, it's probably not that big a deal.  It's only rewriting the ones 
where there is a return ret just before, not all the returns in the code, 
like I was originally thinking.

julia
