Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912Ab2LVF1i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 00:27:38 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:55424 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LVF1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 00:27:36 -0500
Date: Sat, 22 Dec 2012 09:27:30 +0400
From: Dmitry Voytik <dvv.kernel@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: mmarek@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nconf: add j, k and l keys for menu navigation
Message-ID: <20121222052730.GA12608@voyt-hp>
References: <1356117145-14158-1-git-send-email-dvv.kernel@gmail.com>
 <50D4C54D.8020700@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D4C54D.8020700@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 12:23:41PM -0800, Stephen Boyd wrote:
> On 12/21/12 11:12, Dmitry Voytik wrote:
> > Add vi-style keys for menu navigation: press j/k for down/up navigation
> > and l for entering to a submenu. Unfortantely h key is reserved for
> > the items help.
> 
> Maybe you can just add j/k for up/down and then use enter and backspace
> for right/left?

IMHO alternative l key for entering to a submenu will not harm.

