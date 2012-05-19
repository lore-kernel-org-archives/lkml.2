Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028Ab2ESScN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:32:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40922 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab2ESScL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:32:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/8] irqdomain cleanups + identity mapping support
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
References: <1337407908-7421-1-git-send-email-lethal@linux-sh.org>
Date: Sat, 19 May 2012 12:32:09 -0600
Message-Id: <20120519183209.2C6BF3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2012 15:11:40 +0900, Paul Mundt <lethal@linux-sh.org> wrote:
> Here's the current patch stack I've got against the irqdomain code, which
> is about what I need to start being able to reasonably start converting
> the SH INTC subsystem over to it.
> 
> This whole series is also available via git at:
> 
> 	git://github.com/pmundt/linux-sh.git common/irqdomain
> 
> but I've not yet created a signed tag to pull from as there's likely
> still a fair bit of work to do. The diffstat looks innocuous enough, but
> is obviously of no real value in this case:

I'll look though and cherry pick the patches that I think are ready.

g.

