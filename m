Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875Ab1JEPrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 11:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab1JEPrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 11:47:21 -0400
Message-ID: <4E8C7C05.4020600@redhat.com>
Date: Wed, 05 Oct 2011 17:47:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Steve <steveamigauk@yahoo.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: kvm@vger.kernel.org
Subject: Re: Kernel bug - 3.1.0 - rc9
References: <4E8C7A9C.50900@yahoo.co.uk>
In-Reply-To: <4E8C7A9C.50900@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarded to linux-kernel.  You'll need to get better debug output, 
perhaps using a serial console.

Is the issue on the host or guest?  If on the host, it's likely a 
virtualbox bug, report it there.

On 10/05/2011 05:41 PM, Steve wrote:
> I'm not sure exactly where to report this (and the kernel.org 
> "reporting bugs" page is still offline)
>
> RC9 of the 3.1 kernel is causing VirtualBox to fail (certainly here on 
> amd64 - Phenom II 965 quad). syslog output is:
>
> Message from syslogd@Tex at Oct  5 16:16:51 ...
>  kernel:Oops: 0000 [#1] PREEMPT SMP
>
> Message from syslogd@Tex at Oct  5 16:16:51 ...
>  kernel:Stack:
>
> Message from syslogd@Tex at Oct  5 16:16:51 ...
>  kernel:Call Trace:
>
> Message from syslogd@Tex at Oct  5 16:16:51 ...
>  kernel:Code: ac e0 66 8b b3 b8 02 00 00 8b bb b0 02 00 00 48 c7 83 68 
> 02 00 00 00 00 00 00 e8 68 ff ff ff 48 c7 c7 00 aa 62 a0 e8 8e d4 cd e0
>
> Message from syslogd@Tex at Oct  5 16:16:51 ...
>  kernel:CR2: 0000000000000088
>
> vboxsrv drivers install correctly and there are no obvious errors from 
> vbox itself. The bug manifests itself by simply hanging the VM at 
> startup.
>
> Versions pre rc9 work fine in this regard.
>
> I hope that this is of some help.
> -- 
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
error compiling committee.c: too many arguments to function

