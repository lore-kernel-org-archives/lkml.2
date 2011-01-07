Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1AGKE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:04:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab1AGKEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:04:55 -0500
Date: Fri, 7 Jan 2011 11:04:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fix common spelling mistakes
In-Reply-To: <1294319903-11197-1-git-send-email-peterhuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.1101071103440.26685@pobox.suse.cz>
References: <1294319903-11197-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Peter Huewe wrote:

> This patch fixes some very common spelling mistakes. The changes were 
> carried out by hand and are made in documentation/comments only - no 
> functional change. Variables were left untouched on purpose. Linebreaks 
> were also left untouched on purpose.
> 
> The fixed spelling mistakes are:
> WRONG 		-> RIGHT
[ .. snip .. ]
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Hi Peter,

thanks for the fixes. I will be postponing this patchset after -rc1, so 
that we don't get zillions of conflicts now when things are in-flight, and 
will apply it shortly after that.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
