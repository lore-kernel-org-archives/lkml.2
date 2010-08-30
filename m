Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0H3Igx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:36:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:54229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab0H3Igw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:36:52 -0400
Message-ID: <4C7B6C07.6010800@kernel.org>
Date: Mon, 30 Aug 2010 10:29:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <1888320510.1487031283139773505.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1888320510.1487031283139773505.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 08:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/30/2010 05:42 AM, CAI Qian wrote:
>> Hmmm... I can't reproduce it here.  I wonder what the difference is.
>> Can you please trigger sysrq-t after the boot is hung and post the
>> result?
> Sysrq keys did not work at this early stage of booting for me even
> adding sysrq_always_enabled.

I see.  I'll prepare a debug patch which tries to catch long execution
delays in workqueue but in the meantime can you please turn on
hangcheck timer and see whether it triggers after the kernel hangs
during boot?

Thanks.

-- 
tejun
