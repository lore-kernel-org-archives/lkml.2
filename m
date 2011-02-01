Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759Ab1BAHlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 02:41:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40530 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849Ab1BAHlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 02:41:12 -0500
Date: Mon, 31 Jan 2011 23:40:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>, Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
Message-Id: <20110131234028.8744b5fd.akpm@linux-foundation.org>
In-Reply-To: <AANLkTinJLAT0B61Eu1Chn9k9rmbHXa1ZNcedo_m8TZp3@mail.gmail.com>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com>
	<1296470024-26854-2-git-send-email-ohad@wizery.com>
	<20110131153831.dca62146.akpm@linux-foundation.org>
	<AANLkTik-fgCF_W0-DBE6UVTpjqF6Jf=u7bQYkcweEegQ@mail.gmail.com>
	<20110131223859.27169db0.akpm@linux-foundation.org>
	<AANLkTinJLAT0B61Eu1Chn9k9rmbHXa1ZNcedo_m8TZp3@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 09:36:22 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:

> On Tue, Feb 1, 2011 at 8:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> I'll do a quick respin of the patches with that and the
> >> hwspinlock_internal.h comment above.
> >
> > OK..
> >
> > The patch series looks OK to me.
> 
> Can I add your Acked-by on the non-omap parts when I respin the series ?

spose so.  I don't normally do acked-by's.  I think it's my way of
avoiding getting blamed when it all blows up.

