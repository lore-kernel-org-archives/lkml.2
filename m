Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab2CaOD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:03:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62748 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab2CaODz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <201203311334.q2VDYGiL005854@farm-0012.internal.tilera.com>
References: <201203302018.q2UKIFH5020745@farm-0012.internal.tilera.com>
	<CAJd=RBCoLNB+iRX1shKGAwSbE8PsZXyk9e3inPTREcm2kk3nXA@mail.gmail.com>
	<201203311334.q2VDYGiL005854@farm-0012.internal.tilera.com>
Date: Sat, 31 Mar 2012 22:03:53 +0800
Message-ID: <CAJd=RBDEAMgDviSwugt7dHKPGXCCF5jQSDtHdXvt5VnSBmK3bA@mail.gmail.com>
Subject: Re: [PATCH v2] arch/tile: support multiple huge page sizes dynamically
From: Hillf Danton <dhillf@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 3:37 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> This change incorporates Hillf Danton's suggestion to not use a
> macro for arch_make_huge_pte() but instead use the standard hugetlb
> model of providing an empty inline function for every other platform.
>
Oh my god.

First my bad, no clear comment provided:(

What I meant actually is to add something in

include/asm-generic/pgtable.h

#ifndef __HAVE_ARCH_FOO_BAR
the_default_foo_bar()
{
}
#endif

or it is too hard to add default foo_bar for each arch involved.

Say sorry again
Hillf
