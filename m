Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2IXRNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 13:13:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39770 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab2IXRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 13:13:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1209091427160.13346@chino.kir.corp.google.com>
References: <1347137279-17568-1-git-send-email-elezegarcia@gmail.com>
	<1347137279-17568-2-git-send-email-elezegarcia@gmail.com>
	<alpine.DEB.2.00.1209091427160.13346@chino.kir.corp.google.com>
Date: Mon, 24 Sep 2012 14:13:03 -0300
Message-ID: <CALF0-+V9wpWoLe2jmCqpS-y0S89i3sS52cMXn9UvE+mNT-t10Q@mail.gmail.com>
Subject: Re: [PATCH 02/10] mm, slob: Use NUMA_NO_NODE instead of -1
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka,

On Sun, Sep 9, 2012 at 6:27 PM, David Rientjes <rientjes@google.com> wrote:
> On Sat, 8 Sep 2012, Ezequiel Garcia wrote:
>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>
> Acked-by: David Rientjes <rientjes@google.com>
>

Will you pick this (and the rest of cleanup patches)
for v3.7 pull request?
Or is there anything for me to redo?

Thanks,
Ezequiel.
