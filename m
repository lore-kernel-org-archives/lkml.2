Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab2ILISM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:18:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab2ILISJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:18:09 -0400
Message-ID: <5050453B.6040702@redhat.com>
Date: Wed, 12 Sep 2012 11:18:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz> <50504299.2050205@redhat.com> <50504439.3050700@suse.cz>
In-Reply-To: <50504439.3050700@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 11:13 AM, Jiri Slaby wrote:
> 
>>  Please provide the output of vmxcap
>> (http://goo.gl/c5lUO),
> 
>   Unrestricted guest                       no

The big real mode fixes.


> 
>> and a snapshot of kvm_stat while the guest is hung.
> 
> kvm statistics
> 
>  exits                                      6778198  615942
>  host_state_reload                             1988     187
>  irq_exits                                     1523     138
>  mmu_cache_miss                                   4       0
>  fpu_reload                                       1       0

Please run this as root so we get the tracepoint based output; and press
'x' when it's running so we get more detailed output.


-- 
error compiling committee.c: too many arguments to function
