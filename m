Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab1HVKRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:17:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56868 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab1HVKRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:17:37 -0400
Date: Mon, 22 Aug 2011 14:17:30 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        kernel-hardening@lists.openwall.com,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] x86, mm: start mmap allocation for libs from low
 addresses
Message-ID: <20110822101730.GA3346@albatros>
References: <20110812102954.GA3496@albatros>
 <ccea406f-62be-4344-8036-a1b092937fe9@email.android.com>
 <20110816090540.GA7857@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816090540.GA7857@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter, Thomas,

On Tue, Aug 16, 2011 at 13:05 +0400, Vasiliy Kulikov wrote:
> As the changes are not intrusive, we'd want to see this feature in the
> upstream kernel.  If you know why the patch cannot be a part of the
> upstream kernel - please tell me, I'll try to address the issues.

Any comments on the RFC?  Otherwise, may I resend it as a PATCH for
inclusion?

Thanks!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
