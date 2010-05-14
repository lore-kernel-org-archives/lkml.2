Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0ENPpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:45:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499Ab0ENPpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:45:43 -0400
Date: Fri, 14 May 2010 08:42:59 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <20100514153842.GA6398@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005140841320.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org> <20100513171639.GA23708@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005131017070.3711@i5.linux-foundation.org> <20100513181002.GB23708@core.coreip.homeip.net> <alpine.LFD.2.00.1005131253310.3711@i5.linux-foundation.org> <m1aas2kjb6.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1005140751300.3711@i5.linux-foundation.org>
 <20100514153842.GA6398@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 May 2010, Matthew Garrett wrote:
> 
> I think that's true except in the case where the Leading Other OS won't 
> use a device unless it's present in ACPI - that kind of enforcement 
> tends to concentrate vendors' minds, even if they'd otherwise be busy 
> filling data tables with garbage.

Largely true. That said, nobody uses Windows in a headless environment, 
the way people _do_ use Linux and then later plug in a keyboard. 

Also, even with Windows, I do wonder if they have things like cut-off 
dates for trusting ACPI. We certainly do.

		Linus
