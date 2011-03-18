Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1CRDDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 23:03:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932643Ab1CRDDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 23:03:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110317183048.GW7258@atomide.com>
References: <20110317183048.GW7258@atomide.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Mar 2011 20:02:33 -0700
Message-ID: <AANLkTik_Y1uMfVTVVEdPFG0sjW2uYpeeUMKfymho3sd+@mail.gmail.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
To: Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 11:30 AM, Tony Lindgren <tony@atomide.com> wrote:
>
> Please pull omap changes for this merge window from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-for-linus

Btw, that "generic hardware spinlock" thing needs to be hidden from
sane people and architectures that don't need it.

Make platforms that need it "select" it or something. It looks like
nobody but an OMAP4 could _possibly_ ever want to answer 'y' to that
question, SO DON'T ASK IT!

                     Linus
