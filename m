Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2IYHhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:37:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38241 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab2IYHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:37:33 -0400
MIME-Version: 1.0
In-Reply-To: <CALF0-+V9wpWoLe2jmCqpS-y0S89i3sS52cMXn9UvE+mNT-t10Q@mail.gmail.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<1347137279-17568-2-git-send-email-elezegarcia@gmail.com>
	<alpine.DEB.2.00.1209091427160.13346@chino.kir.corp.google.com>
	<CALF0-+V9wpWoLe2jmCqpS-y0S89i3sS52cMXn9UvE+mNT-t10Q@mail.gmail.com>
Date: Tue, 25 Sep 2012 10:37:32 +0300
X-Google-Sender-Auth: Pe846mwUDfCn7cpcNmIlzKOSUwA
Message-ID: <CAOJsxLHBqXEeUK4TxjF50BH3yzbmMrXW0FaXZgbn2rbyBLdoFw@mail.gmail.com>
Subject: Re: [PATCH 02/10] mm, slob: Use NUMA_NO_NODE instead of -1
From: Pekka Enberg <penberg@kernel.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 8:13 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> Will you pick this (and the rest of cleanup patches)
> for v3.7 pull request?
> Or is there anything for me to redo?

I merged all the patches except for the last one which conflicts with
the kmem/memcg changes.
