Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2AWNQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 08:16:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60307 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394Ab2AWNQY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 08:16:24 -0500
MIME-Version: 1.0
In-Reply-To: <1312839019-17987-1-git-send-email-malchev@google.com>
References: <1312839019-17987-1-git-send-email-malchev@google.com>
Date: Mon, 23 Jan 2012 15:16:23 +0200
X-Google-Sender-Auth: n8Bng3wa_1lpdwhJaQfe4LFGbWc
Message-ID: <CAOJsxLGFRLb=-sKfSuzxJ=MHtJ=x9mmCEqgY3B4UdFqppfz-sg@mail.gmail.com>
Subject: Re: [PATCH 1/2] slub: extend slub_debug to handle multiple slabs
From: Pekka Enberg <penberg@kernel.org>
To: Iliyan Malchev <malchev@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Iliyan,

On Tue, Aug 9, 2011 at 12:30 AM, Iliyan Malchev <malchev@google.com> wrote:
> Extend the slub_debug syntax to "slub_debug=<flags>[,<slub>]*", where <slub>
> may contain an asterisk at the end.  For example, the following would poison
> all kmalloc slabs:
>
>        slub_debug=P,kmalloc*
>
> and the following would apply the default flags to all kmalloc and all block IO
> slabs:
>
>        slub_debug=,bio*,kmalloc*
>
> Signed-off-by: Iliyan Malchev <malchev@google.com>

Ping? I didn't see followup patches that addressed Christoph's review
comments. I think the feature makes sense so it'd be good to have it
in mainline.

                        Pekka
