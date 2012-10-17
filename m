Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2JQWJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 18:09:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57013 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab2JQWJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 18:09:32 -0400
Date: Wed, 17 Oct 2012 15:09:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] aoe: print warning regarding a common reason for
 dropped transmits
Message-Id: <20121017150930.aae0cf0b.akpm@linux-foundation.org>
In-Reply-To: <8691a45b39d4f93743f93360c467789a75e25fb7.1350331035.git.ecashin@coraid.com>
References: <cover.1350331035.git.ecashin@coraid.com>
	<8691a45b39d4f93743f93360c467789a75e25fb7.1350331035.git.ecashin@coraid.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012 18:42:43 -0700
Ed Cashin <ecashin@coraid.com> wrote:

> Dropped transmits are not common, but when they do occur, increasing
> the transmit queue length often helps.
>
> ...
>
> +/* enters with txlock held
> + *
> + * Use __must_hold(&txlock) for sparse when upcoming patch adds it to
> + * compiler.h.
> + */

Let's just make that change now and I'll take care of getting
linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
merged ahead of this one.

