Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0K2Wts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 17:49:48 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:49065 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0K2Wtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 17:49:47 -0500
Message-ID: <4CF42E07.40207@pavlinux.ru>
Date: Tue, 30 Nov 2010 01:49:43 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Repalce strncmp by memcmp
References: <4CF30B46.4000203@pavlinux.ru>	 <1291042737.30543.730.camel@gandalf.stny.rr.com>	 <4CF401DD.4000908@pavlinux.ru>	 <1291069113.30543.876.camel@gandalf.stny.rr.com> <1291069616.30543.879.camel@gandalf.stny.rr.com>
In-Reply-To: <1291069616.30543.879.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.11.2010 01:26, Steven Rostedt wrote:
> On Mon, 2010-11-29 at 17:18 -0500, Steven Rostedt wrote:
>
>> Um, do you realize that the kernel does not always use the same memcmp
>> as gcc.
>>
> Note, I'm not against the change, because in 99% of the cases, memcmp()
> can and will be faster, and we don't need to worry about these strange
> cases.
>
> What I'm against is a blind s/strncmp/memcmp/ of the kernel, because it
> may have side effects that you may not have thought of.
>
Then we have to hang a large banner that is visible to all developers.
"Change wherever possible strncmp to memcmp," :)

-- 

                                                         Pavel.

