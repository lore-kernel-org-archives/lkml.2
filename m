Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2I0NBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 09:01:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9017 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab2I0NBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 09:01:22 -0400
Message-ID: <50644E05.9000704@parallels.com>
Date: Thu, 27 Sep 2012 17:00:53 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>
Subject: Re: [patch 1/7] procfs: Add ability to plug in auxiliary fdinfo providers
References: <20120912212906.407242774@openvz.org> <20120912213507.272670512@openvz.org> <20120917181810.GH22360@moon>
In-Reply-To: <20120917181810.GH22360@moon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2012 10:18 PM, Cyrill Gorcunov wrote:
> On Thu, Sep 13, 2012 at 01:29:07AM +0400, Cyrill Gorcunov wrote:
>> This patch brings ability to print out auxiliary data associated
>> with file in procfs interface /proc/pid/fdinfo/fd.
>>
>> In particular further patches make eventfd, evenpoll, signalfd
>> and fsnotify to print additional information complete enough
>> to restore these objects after checkpoint.
>>
>> To simplify the code we add show_fdinfo callback inside
>> struct file_operations (as Al and Pavel are proposing).
>>
> 
> Hi, sorry for bothering but is there some opinions on this series?

Al, we'd appreciate if you share your plans about this series. Please.

> (I've found that epoll change log has not been well refreshed and
>  says that this fdinfo feature is config-checkpoint-restore dependant,
>  but in real this config entry was ripped off during conversation).
> 
> So, at moment I somehow confused since it's a bit unclear where to
> move, either this series is more-less acceptible or not. I could
> bring back all config-checkpoint-restore dependency (since I still
> believe this feature better to be enabled not by default but iif
> user has asked fo it).
> .
> 

Thanks,
Pavel
