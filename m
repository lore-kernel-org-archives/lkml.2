Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab2FTIHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:07:50 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44784 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2FTIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <1340088918-4081-1-git-send-email-rabin.vincent@stericsson.com>
References: <1340088918-4081-1-git-send-email-rabin.vincent@stericsson.com>
Date: Wed, 20 Jun 2012 10:07:42 +0200
Message-ID: <CACRpkda0uOB_4i0aa4DWMGKamXnDnkJeZnRuo-iwsrcarO6pkA@mail.gmail.com>
Subject: Re: [PATCH] uprobes: move function declarations out of arch
From: Linus Walleij <linus.walleij@linaro.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 8:55 AM, Rabin Vincent
<rabin.vincent@stericsson.com> wrote:

> Move the arch_* function declarations to the common header so that they
> don't have to be copy/pasted verbatim across arches.
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>

Looping in Arnd as arch maintainer to get some traction.
(Looks good to me!)

Yours,
Linus Walleij
