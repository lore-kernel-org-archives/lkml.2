Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab0EPJF3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 05:05:29 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:56941 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0EPJF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 05:05:28 -0400
Date: Sun, 16 May 2010 11:05:23 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: ERR_PTR and PTR_ERR
In-Reply-To: <Pine.LNX.4.64.1005161055580.6573@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1005161104520.6573@ask.diku.dk>
References: <Pine.LNX.4.64.1005161055580.6573@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010, Julia Lawall wrote:

> I see a number of occurrences of code like the following:
> 
>  	if (IS_ERR(alg))
> 		return ERR_PTR(PTR_ERR(alg));
> 
> Is there any reason why the second line couldn't just be return alg?

Hmm, never mind.  It seems to address a type problem.

julia
