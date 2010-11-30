Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0K3WUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:20:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49847 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0K3WUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:20:42 -0500
MIME-Version: 1.0
X-Originating-IP: [192.91.75.238]
In-Reply-To: <20101130190058.GX17222@atomide.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101130190058.GX17222@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 30 Nov 2010 14:20:21 -0800
Message-ID: <AANLkTi=73VQeBj_M_PJO5OzJJDgWOXHkw31tN4z-nqMu@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:00 AM, Tony Lindgren <tony@atomide.com> wrote:
> Do we even need the hwspin_lock variants,

I personally don't have any specific use case in mind.

It's just a simple wrapper over the _timeout variants, provided for
API completeness, but -

> why can't we always use the hwspin_lock_timeout variants?

We can. I can just remove the _lock variants.
