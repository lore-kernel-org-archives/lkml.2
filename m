Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab2KFByT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:54:19 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53949 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab2KFByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1211051721030.24937@chino.kir.corp.google.com>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org>
	<1352156701-4038-104-git-send-email-keescook@chromium.org>
	<alpine.DEB.2.00.1211051721030.24937@chino.kir.corp.google.com>
Date: Mon, 5 Nov 2012 17:54:16 -0800
X-Google-Sender-Auth: aKaPncuvdJm3ziwJ8GfvETt7uvY
Message-ID: <CAGXu5jLq63rpM0wargy-DF6jX_ncDnjMbzjNYAYbx+5uNKmTMA@mail.gmail.com>
Subject: Re: [PATCH 103/104] mm: remove depends on CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 5:22 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 5 Nov 2012, Kees Cook wrote:
>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index a3f8ddd..679945e 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1,6 +1,5 @@
>>  config SELECT_MEMORY_MODEL
>>       def_bool y
>> -     depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
>>
>>  choice
>>       prompt "Memory model"
>
> I thought you agreed to only drop EXPERIMENTAL here in
> http://marc.info/?l=linux-kernel&m=135103415901094 and leave
> ARCH_SELECT_MEMORY_MODEL, which you've orphaned with the above, for phase
> two of your effort?

Ah! Yes, thanks. I'll restore that.

-Kees

-- 
Kees Cook
Chrome OS Security
