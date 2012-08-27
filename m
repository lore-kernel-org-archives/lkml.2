Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2H0M0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:26:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51777 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2H0M0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:26:38 -0400
MIME-Version: 1.0
In-Reply-To: <20120827123917.3313dfda@thinkpad>
References: <20120823171733.595087166@de.ibm.com>
	<20120823171854.580076595@de.ibm.com>
	<CAJd=RBBJa934R53AHYVhkxE+2e=RiKU1zJXsLMCBFw_NHZE0oQ@mail.gmail.com>
	<20120827123917.3313dfda@thinkpad>
Date: Mon, 27 Aug 2012 20:26:36 +0800
Message-ID: <CAJd=RBA-GyFvQ3_vMVqhBS89QT_xDLEBbysBzhCA7sU7rt00+g@mail.gmail.com>
Subject: Re: [RFC patch 3/7] thp: make MADV_HUGEPAGE check for mm->def_flags
From: Hillf Danton <dhillf@gmail.com>
To: gerald.schaefer@de.ibm.com
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 6:39 PM, Gerald Schaefer
<gerald.schaefer@de.ibm.com> wrote:
> Hmm, architecture #ifdefs in common code are ugly. I'd rather keep
> the check even if it is redundant right now for other architectures
> than s390. It is not a performance critical path, and there may be
> other users of that in the future.

Fair if no changes in semantics
