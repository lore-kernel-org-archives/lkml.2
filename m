Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab2JGWaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 18:30:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51573 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JGWaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 18:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
References: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
Date: Mon, 8 Oct 2012 00:30:21 +0200
Message-ID: <CAFLxGvw3yMf9eYd-5X3ZNGNmQnGvMNUAGpJ+D5ZhNe-2a8vebw@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: Add option to disable gcc automatic inlining
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        mmarek@suse.cz, sam@ravnborg.org, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 9:18 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> The new option is CONFIG_CC_DISABLE_AUTO_INLINE and it's
> located at:
>   * Kernel hacking
>     * Disable gcc automatic inlining

Can you guarantee that this will still produce a valid kernel?
AFAIK we have some functions which have to be inlined in any case.

-- 
Thanks,
//richard
