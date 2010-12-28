Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab0L1GRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:17:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:38351 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab0L1GRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:17:00 -0500
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <mgalbraith@suse.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <201012280108.12807.gene.heskett@gmail.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <1292861059.15207.7.camel@marge.simson.net>
	 <1293515683.6930.16.camel@marge.simson.net>
	 <201012280108.12807.gene.heskett@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 07:16:48 +0100
Message-ID: <1293517008.6930.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 01:08 -0500, Gene Heskett wrote:
> On Tuesday, December 28, 2010, Mike Galbraith wrote:

> >(either it's christmas, or nobody cares to try it.  ho ho hum:)
> 
> Mike, I'd be glad to try it, but the last kernel I was able to make the 
> nvidia drivers install on was 2.6.36.1-latencyfix, which had your earier 
> patches in it, and it is working _very_ well.

It wouldn't do diddly spit by itself anyway, needs someone to stick
yield_to(amigo) in interesting spots.  Might not do diddly spit even
then :)

	-Mike

