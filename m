Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3ABUkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:40:05 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:63785 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3ABUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1301020201510.18049@eggly.anvils>
References: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils> <alpine.LNX.2.00.1301020201510.18049@eggly.anvils>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 2 Jan 2013 15:39:42 -0500
Message-ID: <CAHGf_=rfmdmC+u48gjPvCTQ9=t5MEKY4DmxUuHrkJf9AN9BZ8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] mempolicy: remove arg from mpol_parse_str, mpol_to_str
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 5:04 AM, Hugh Dickins <hughd@google.com> wrote:
> Remove the unused argument (formerly no_context) from mpol_parse_str()
> and from mpol_to_str().
>
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
