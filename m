Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0IWP3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:29:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:38272 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab0IWP3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:29:16 -0400
Subject: Re: [PATCH 2/5] Add mkcis - a program that can create .cis from
 text description
From: David Woodhouse <dwmw2@infradead.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
In-Reply-To: <1285255197-9262-2-git-send-email-dbaryshkov@gmail.com>
References: <1285255197-9262-1-git-send-email-dbaryshkov@gmail.com>
	 <1285255197-9262-2-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 16:29:12 +0100
Message-ID: <1285255752.10687.20.camel@i7.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.33.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 19:19 +0400, Dmitry Eremin-Solenikov wrote:
> For CIS files (describing hardware on PCMCIA and some other busses)
> binary file isn't the 'preferred for for modification' in most cases.
> pcmcia-cs project have developed pack_cis program which can be used
> (and was used most probably) to generate .cis files from simple text
> descriptions. Import this code to the kernel under the name of mkcis.

This is useful, thanks -- but NACK. The firmware/ directory of the
kernel will hopefully die soon, and is no longer what's actually shipped
by many distributions.

We should be concentrating on the linux-firmware.git repository instead.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

