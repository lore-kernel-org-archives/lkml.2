Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab1ABKaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 05:30:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:54460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1ABKaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 05:30:17 -0500
Subject: Re: [patch 1/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
From: David Woodhouse <dwmw2@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@suse.de>, "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 02 Jan 2011 10:29:37 +0000
Message-ID: <1293964177.2470.16.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 20:02 -0800, David Rientjes wrote:
> The meaning of CONFIG_EMBEDDED has long since been obsoleted; the option
> is used to configure any non-standard kernel with a much larger scope
> than only small devices.

I think it was misnamed from the very beginning; it never really made
sense to call it 'EMBEDDED'. Too many people abuse the term 'embedded'.

> This patch renames the option to CONFIG_EXPERT in init/Kconfig and fixes
> references to the option in the same file.  Followup patches will fix the
> remainder of the occurrences in the tree.

Thanks for doing this.

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

