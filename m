Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423849Ab2LFPlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:41:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44849 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2LFPlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:41:52 -0500
Date: Thu, 6 Dec 2012 07:38:33 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH resend 0/4] ARM: KDB FIQ debugger
Message-ID: <20121206153832.GA27012@lizard>
References: <20121123002957.GA31679@lizard.mcd25758.sjc.wayport.net>
 <20121206151726.GA23394@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121206151726.GA23394@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 07:17:26AM -0800, Anton Vorontsov wrote:
> On Thu, Nov 22, 2012 at 04:29:57PM -0800, Anton Vorontsov wrote:
> > Hello Andrew, Russell,
> > 
> > The KDB/NMI core support has been merged into v3.7-rc1, so the only ARM
> > bits are pending now.
> > 
> > I addressed all the comments ~two month ago, and since then just resending
> > these patches. I know we're all busy, so no blaming. :) But then let's
> > pass this via -mm?
> 
> Guys, could someone take a look at this?.. Considering the low impact of
> this series (it mostly adds code, and the only modification part the one
> that just moves things around), maybe it still has some chance to get into
> 3.9?

Oops, I mean 3.8, of course. :)
