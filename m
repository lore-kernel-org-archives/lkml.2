Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab2EKQ0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:26:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45884 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2EKQ0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2012 09:26:28 -0700
X-Google-Sender-Auth: pLkiFzkUHP-0aU3gACuSXSpMAcQ
Message-ID: <CA+55aFzKkR4sntktx63jstftfw_Grf1A5D97VzXo=hGS2R34=Q@mail.gmail.com>
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 1:00 AM, Hugh Dickins <hughd@google.com> wrote:
>
> Commit 93278814d359 "mm: fix division by 0 in percpu_pagelist_fraction()"
> mistakenly initialized percpu_pagelist_fraction to the sysctl's minimum 8,
> which leaves 1/8th of memory on percpu lists (on each cpu??); but most of
> us expect it to be left unset at 0 (and it's not then used as a divisor).

Applied.

                      Linus
