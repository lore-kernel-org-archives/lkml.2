Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab2CUWTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:19:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964935Ab2CUWTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:19:03 -0400
Date: Wed, 21 Mar 2012 15:19:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hillf Danton <dhillf@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH v4 2/3] thp: add HPAGE_PMD_* definitions for
 !CONFIG_TRANSPARENT_HUGEPAGE
Message-Id: <20120321151900.42234501.akpm@linux-foundation.org>
In-Reply-To: <CAP=VYLoGSckJH+2GytZN0V0P3Uuv-PiVneKbFsVb5kQa3kcTCQ@mail.gmail.com>
References: <1331591456-20769-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1331591456-20769-2-git-send-email-n-horiguchi@ah.jp.nec.com>
	<CAP=VYLoGSckJH+2GytZN0V0P3Uuv-PiVneKbFsVb5kQa3kcTCQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 18:07:41 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> On Mon, Mar 12, 2012 at 6:30 PM, Naoya Horiguchi
> <n-horiguchi@ah.jp.nec.com> wrote:
> > These macros will be used in later patch, where all usage are expected
> > to be optimized away without #ifdef CONFIG_TRANSPARENT_HUGEPAGE.
> > But to detect unexpected usages, we convert existing BUG() to BUILD_BUG().
> 
> Just a heads up that this showed up in linux-next today as the
> cause of a new build failure for an ARM board:

Dammit.

> http://kisskb.ellerman.id.au/kisskb/buildresult/5930053/

Site is dead.  What was failure, please?
