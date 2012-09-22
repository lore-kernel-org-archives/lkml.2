Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2IVLQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:16:18 -0400
Received: from outbound-mail02.westnet.com.au ([203.10.1.243]:27981 "EHLO
	outbound-mail02.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752947Ab2IVLQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:16:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgCACGdXVB787/Z/2dsb2JhbAANOL0eBASELAEBAQQ4QAEQCxIGCRYPCQMCAQIBNw4GDQEHAQGHbgEdpRSTWYschioDlnqSBg
X-IronPort-AV: E=Sophos;i="4.80,467,1344182400"; 
   d="scan'208";a="268336530"
Message-ID: <505D9DFB.8080002@westnet.com.au>
Date: Sat, 22 Sep 2012 21:16:11 +1000
From: Greg Ungerer <gregungerer@westnet.com.au>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
References: <20120917032651.GU13973@ZenIV.linux.org.uk> <1348244799-16013-1-git-send-email-msalter@redhat.com> <20120921183934.GK13973@ZenIV.linux.org.uk>
In-Reply-To: <20120921183934.GK13973@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2012 04:39 AM, Al Viro wrote:
> On Fri, Sep 21, 2012 at 12:26:36PM -0400, Mark Salter wrote:
>> Here are a set of c6x patches to work with your experimental-kernel_thread
>> branch.
>>
>> Mark Salter (3):
>>    c6x: add ret_from_kernel_thread(), simplify kernel_thread()
>>    c6x: switch to generic kernel_execve
>>    c6x: switch to generic sys_execve
>
> Applied and pushed...
>
> FWIW, the current status:
>
> alpha - done, tested on hardware
> arm - done, tested on qemu
> c6x - done by maintainer
> frv - done, untested
> m68k - done, tested on aranym; there's a known issue in copy_thread() in
> case of coldfire-MMU, presumably to be handled in m68k tree (I can do it
> in this one instead, if m68k folks would prefer it that way)

I sent the patch to the m68k-linux list. Its been acked by Geert.

  http://marc.info/?l=linux-m68k&m=134742688015639&w=2

I was going to push it through the m68knommu git tree, but I don't mind
if you would rather take it with your changes.

Regards
Greg

