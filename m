Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0IIOZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:25:00 -0400
Received: from mv-drv-hcb003.ocn.ad.jp ([118.23.109.133]:42425 "EHLO
	mv-drv-hcb003.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0IIOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:24:57 -0400
Date: Thu, 09 Sep 2010 23:24:53 +0900 (JST)
Message-Id: <20100909.232453.31646362.anemo@mba.ocn.ne.jp>
To: cernekee@gmail.com
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] MIPS: Move FIXADDR_TOP into spaces.h
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <55645e13fcf442f6641b3eb187cab302@localhost>
References: <55645e13fcf442f6641b3eb187cab302@localhost>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010 12:59:15 -0700, Kevin Cernekee <cernekee@gmail.com> wrote:
> Memory maps and addressing quirks are normally defined in <spaces.h>.
> There are already three targets that need to override FIXADDR_TOP, and
> others exist.  This will be a cleaner approach than adding lots of
> ifdefs in fixmap.h .

Looks OK for me.  Thanks.

---
Atsushi Nemoto
