Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758385Ab2HWMFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:05:05 -0400
Received: from seven.medozas.de ([5.9.24.206]:50337 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab2HWMFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:05:02 -0400
Date: Thu, 23 Aug 2012 14:05:01 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michel Lespinasse <walken@google.com>, riel@redhat.com,
        peterz@infradead.org, daniel.santos@pobox.com, aarcange@redhat.com,
        dwmw2@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v3 2/9] rbtree: add __rb_change_child() helper function
In-Reply-To: <20120820151710.eeed9bcf.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.01.1208231356010.30263@frira.zrqbmnf.qr>
References: <1345500331-10546-1-git-send-email-walken@google.com> <1345500331-10546-3-git-send-email-walken@google.com> <20120820151710.eeed9bcf.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2012-08-21 00:17, Andrew Morton wrote:
>
>If we have carefully made a decision to inline a function, we should
>(now) use __always_inline.
>If we have carefully made a decision to not inline a function, we
>should use noinline.
>
>If we don't care, we should omit all such markings.
>This leaves no place for "inline"?

The current use of "inline" is to shut up the compiler, otherwise gcc
would emit a warning about "function declared but not used".
