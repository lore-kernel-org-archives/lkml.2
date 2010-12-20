Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab0LTSqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:46:16 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59235 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0LTSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:46:15 -0500
Date: Mon, 20 Dec 2010 13:46:11 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Daniel Walker <dwalker@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] hvc_dcc: Simplify assembly for v6 and v7 ARM
In-Reply-To: <4D0FA2EE.90703@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1012201344580.10437@xanadu.home>
References: <20101201192856.GA731@suse.de>  <1292649385-28771-1-git-send-email-sboyd@codeaurora.org> <1292867461.27552.15.camel@m0nster> <4D0FA2EE.90703@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010, Stephen Boyd wrote:

> On 12/20/2010 09:51 AM, Daniel Walker wrote:
> >
> > I would expect to see three patches. One that adds volatile, which
> > appears to be a good fix. Another patch that changes the assembly lines,
> > and another that does the clean up. The last two are more controversial
> > ones
> 
> Ok. I'll send a series later today to give some more time for feedback.

I think you can do that right away.  Splitting the patch will make that 
feedback easier to provide.


Nicolas
