Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0H2Mnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 08:43:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:48323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab0H2Mnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 08:43:49 -0400
Message-ID: <4C7A5455.7060905@kernel.org>
Date: Sun, 29 Aug 2010 14:36:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <779893521.1479771283083393771.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <779893521.1479771283083393771.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 29 Aug 2010 12:43:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/29/2010 02:03 PM, CAI Qian wrote:
> 
> ----- "Tejun Heo" <tj@kernel.org> wrote:
> 
>> On 08/29/2010 01:56 PM, CAI Qian wrote:
>>> It is easy to reproduce by passing maxcpus=1 to the first kernel.
>>
>> Do you mean booting w/ maxcpus=1 hangs the first kernel even w/o
>> kdump?
> Yes, here was the log,

Hmmm... I can't reproduce it here.  I wonder what the difference is.
Can you please trigger sysrq-t after the boot is hung and post the
result?

Thanks.

-- 
tejun
