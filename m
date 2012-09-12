Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab2ILIUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:20:33 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36964 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab2ILIUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:20:30 -0400
Message-ID: <505045CA.7080504@suse.cz>
Date: Wed, 12 Sep 2012 10:20:26 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: qemu-kvm loops after kernel udpate
References: <504F7ED8.1030702@suse.cz> <20120911190303.GA3626@amt.cnet> <504F93F1.2060005@suse.cz> <50504299.2050205@redhat.com> <50504439.3050700@suse.cz> <5050453B.6040702@redhat.com>
In-Reply-To: <5050453B.6040702@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:18 AM, Avi Kivity wrote:
> On 09/12/2012 11:13 AM, Jiri Slaby wrote:
>> kvm statistics
>>
>>  exits                                      6778198  615942
>>  host_state_reload                             1988     187
>>  irq_exits                                     1523     138
>>  mmu_cache_miss                                   4       0
>>  fpu_reload                                       1       0
> 
> Please run this as root so we get the tracepoint based output; and press
> 'x' when it's running so we get more detailed output.

I need to build a kernel with trace points enabled first... I will
return later today.

thanks,
-- 
js
suse labs
