Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1FPFE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 01:04:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750731Ab1FPFEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 01:04:55 -0400
MIME-Version: 1.0
In-Reply-To: <1308134610.15315.35.camel@twins>
References: <20110615102909.GA23759@sli10-conroe.sh.intel.com> <1308134610.15315.35.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 22:04:32 -0700
Message-ID: <BANLkTi=qNDspwohsqWiPVjz+ECb9wdd0Zw@mail.gmail.com>
Subject: Re: [PATCH]mm: use correct address for pte_unmap_unlock in zap_pte_range
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 3:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Apparently it hasn't made its way to Linus though.

Andrew sent his queue (well, at least part of it) to me today, so now
it's commit 5f1a19070b16 ("mm: fix wrong kunmap_atomic() pointer") in
the current -git tree.

                      Linus
