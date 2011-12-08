Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab1LHRIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 12:08:52 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47209 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1LHRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 12:08:50 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.57.177]
In-Reply-To: <20111208170114.GZ31337@atomide.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
 <1319536106-25802-5-git-send-email-ohad@wizery.com> <CAK=WgbZvH3eiouryKDenC_x0LdDcHFuumhfoeY4ueiwT5r0cxA@mail.gmail.com>
 <20111208170114.GZ31337@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Dec 2011 19:08:29 +0200
Message-ID: <CAK=WgbYj1QzAqc=AAJZ7XCTjzpeB-xXWyRMCb49FypbYzxD=Kg@mail.gmail.com>
Subject: Re: [PATCH 4/7] amp/omap: add a remoteproc driver
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 7:01 PM, Tony Lindgren <tony@atomide.com> wrote:
> The platform init code looks OK to me. Please also start considering
> how to do the DT bindings for it.

Will do. Thanks !
