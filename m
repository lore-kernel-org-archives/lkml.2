Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0E1EJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:09:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab0E1EJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:09:37 -0400
Date: Thu, 27 May 2010 21:06:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Florian Ragwitz <rafl@debian.org>, Arjan Opmeer <arjan@opmeer.net>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.35-rc0
In-Reply-To: <20100528024646.GA21961@core.coreip.homeip.net>
Message-ID: <alpine.LFD.2.00.1005272055250.11382@i5.linux-foundation.org>
References: <20100520165243.GA20861@core.coreip.homeip.net> <alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org> <20100528024646.GA21961@core.coreip.homeip.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 May 2010, Dmitry Torokhov wrote:
> 
> I do hope we will sort it out because there is a demand to make it use
> Synaptics driver so it is configurable. Any chance I could persuade you
> to stick "options psmouse proto=imps" in your daughter's laptop for the
> time being?

You mean "psmouse.proto=imps" on the command line, I presume.

> Is it Mini 10 BTW?

No. It's a Inspiron 11z. Much better CPU, better screen, yet still pretty 
small.

		Linus
