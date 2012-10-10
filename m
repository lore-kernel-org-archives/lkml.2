Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2JJCw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 22:52:29 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43811 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2JJCw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 22:52:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvw3yMf9eYd-5X3ZNGNmQnGvMNUAGpJ+D5ZhNe-2a8vebw@mail.gmail.com>
References: <1349637532-27466-1-git-send-email-elezegarcia@gmail.com>
	<CAFLxGvw3yMf9eYd-5X3ZNGNmQnGvMNUAGpJ+D5ZhNe-2a8vebw@mail.gmail.com>
Date: Tue, 9 Oct 2012 23:52:27 -0300
Message-ID: <CALF0-+WQX6vbDx+qWDw-rc-FEXV2ESp7621Q4cbwbFPcpgBYiA@mail.gmail.com>
Subject: Re: [PATCH v2] Makefile: Add option to disable gcc automatic inlining
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org, Tim Bird <tim.bird@am.sony.com>,
        mmarek@suse.cz, sam@ravnborg.org, rientjes@google.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Richard,

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

As a matter of fact, you're right... this breaks compilation on my
desktop machine.
I guess I'll have to give it a respin :-(

Thanks for the feedback.

    Ezequiel
