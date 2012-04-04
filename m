Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2DDF7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 01:59:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58350 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2DDF7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 01:59:12 -0400
Message-ID: <4F7BE315.6030305@gmail.com>
Date: Wed, 04 Apr 2012 13:58:45 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [Patch v2] proc: clean up /proc/<pid>/environ handling
References: <20120328153936.495f567a.akpm@linux-foundation.org> <1333441703-8180-1-git-send-email-xiyou.wangcong@gmail.com> <20120403150225.GA6152@redhat.com>
In-Reply-To: <20120403150225.GA6152@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 11:02 PM, Oleg Nesterov wrote:
>
> Again, this is identical with mem_release(), proc_environ_operations
> can simply use it instead.
>

Yeah, I noticed that, just not sure about it is worth effort to unify 2 
functions... :-/ As you prefer, I will do that.

Thanks.
