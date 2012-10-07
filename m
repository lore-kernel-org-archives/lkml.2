Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2JGWfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 18:35:17 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60510 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2JGWfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 18:35:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvw3yMf9eYd-5X3ZNGNmQnGvMNUAGpJ+D5ZhNe-2a8vebw@mail.gmail.com>
References: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
	<CAFLxGvw3yMf9eYd-5X3ZNGNmQnGvMNUAGpJ+D5ZhNe-2a8vebw@mail.gmail.com>
Date: Sun, 7 Oct 2012 19:35:13 -0300
Message-ID: <CALF0-+X1HBv_mhZC80nFxeqxksb7ZG=rPeij2mGRLn+T0qDfOg@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: Add option to disable gcc automatic inlining
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        mmarek@suse.cz, sam@ravnborg.org, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 7:30 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Sun, Oct 7, 2012 at 9:18 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
>> The new option is CONFIG_CC_DISABLE_AUTO_INLINE and it's
>> located at:
>>   * Kernel hacking
>>     * Disable gcc automatic inlining
>
> Can you guarantee that this will still produce a valid kernel?
> AFAIK we have some functions which have to be inlined in any case.
>

Not sure what you mean by "valid" kernel. I'm using a kernel with
this, of course.
If you mean always_inline attribute: that's a whole different story.
This option only disables *automatic* inlining.

   Ezequiel
