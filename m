Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab2EGEWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 00:22:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55294 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab2EGEWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 00:22:13 -0400
Message-ID: <1336364531.7272.7.camel@marge.simpson.net>
Subject: Re: Strange behaviour after uptime of 208-209 days
From: Mike Galbraith <mgalbraith@suse.de>
To: Christoph Bartoschek <ponto@pontohonk.de>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 07 May 2012 06:22:11 +0200
In-Reply-To: <iaej79-g6o.ln1@homer.bruehl.pontohonk.de>
References: <iaej79-g6o.ln1@homer.bruehl.pontohonk.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-07 at 01:33 +0200, Christoph Bartoschek wrote: 
> Hi,
> 
> we run kernel 2.6.37.6 from opensuse 11.4. All machines with uptimes more 
> than 208 days show strange behaviour. The scheduler seems to avoid some 
> cores. For example on a 12 core machine only 3 cores are used. I see the 
> following messages in the logfiles

Ah, 208 day bugfixes went to stable, but not to 2.6.37.  Dunno if that
kernel is still being maintained, but please file a bug with opensuse.

-Mike

