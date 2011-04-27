Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1D0AIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 20:08:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61377 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1D0AH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 20:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sFuAOZPGbB3i8LJlHvCHg7RLzb/YlXWSZPwecVJAVIOHApG1N7YbO44jM0uyy173uo
         9fyVLTLTOonvAmzJKDVRM7vg2PU56BFlrFz7/0QL2akbEHBSaCWcEI918aM+FtJVVcL4
         iHN9Sv5TuJhAq97Oau/h2kIDQlRM0NPnL00gY=
MIME-Version: 1.0
In-Reply-To: <BANLkTikVLj3W6dSNRERntjOcX0kh-wrJYg@mail.gmail.com>
References: <1303728272-11408-1-git-send-email-leemgs1@gmail.com>
	<1303728272-11408-4-git-send-email-leemgs1@gmail.com>
	<20110425084508.dda5ec8f.randy.dunlap@oracle.com>
	<BANLkTi=psQRm9W9uXBgCEyYp-oEA0d0GVA@mail.gmail.com>
	<BANLkTikVLj3W6dSNRERntjOcX0kh-wrJYg@mail.gmail.com>
Date: Wed, 27 Apr 2011 09:07:57 +0900
Message-ID: <BANLkTinn3pL-E4+DQKGvPXxKysbHkvA08Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] munmap: kbuild menu for munmap interface
From: Geunsik Lim <leemgs1@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 7:51 AM, Hugh Dickins <hughd@google.com> wrote:
> On Mon, Apr 25, 2011 at 5:42 PM, Geunsik Lim <leemgs1@gmail.com> wrote:
>> I will modify contents that you commented.
>
> Thank you for making the effort, but we would much prefer to eliminate
> ZAP_BLOCK_SIZE than have a configurable ZAP_BLOCK_SIZE.  So I don't
> think you need update the contents here.
>
> Peter's preemptible mmu_gather work is expected to be included in the
> next mmotm.  Please test on that, and if it does not meet your needs,
> do let us know.
Thank you comments. As I answered to Peter, When we are running Linux kernel
at a various system (e.g: Server/Desktop/Embedded),
If preemptible mmu_gather work is sufficient to get real-fast or
real-time(= preemptive property?)  selectively, I am ok.
>
> Thanks,
> Hugh
>



-- 
Regards,
Geunsik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
