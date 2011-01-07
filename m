Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab1AGJxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:53:12 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49735 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab1AGJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MjdZA7qiPDBIvWXBOa2fBr3F/POxCiOiS0tV3J8M5nCR5BzuFVDvnZ1Rzj69Jv3W1d
         mmEXCQiDLqY0ckw2vGMN5QWBzvDfLUOnrrOeXHK+afkU6vgdnUR2wAN7bUG1JeARZjU9
         nNMixZNTFoAgV90blSa+bJvI95KDAjWoPhK3k=
Message-ID: <4D26E282.6040301@gmail.com>
Date: Fri, 07 Jan 2011 12:53:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] x86, NMI: die_notifier and default_do_nmi cleanups
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
In-Reply-To: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 12:18 AM, Don Zickus wrote:
> This is another version of the NMI rewrite patches I sent previously.  I
> take it those patches were too thick to be reviewed easily, so I broke out
> the patches differently to make it easier to review.  Hopefully it doesn't
> look as scary.
> 
> The bulk of the patch adds priorities to the die_chain notifiers for NMI
> events and removes the DIE_NMI_IPI event.  There are some other cleanups
> too, which include removing the restriction of the BSP cpu to process 
> external NMIs.
> 
> Cheers,
> Don
> 
> Don Zickus (5):
>   x86: Convert some devices to use DIE_NMIUNKNOWN
>   x86, NMI: Add priorities to handlers
>   x86, NMI: Remove DIE_NMI_IPI
>   x86, NMI: Allow NMI reason io port (0x61) to be processed on any CPU
>   x86, NMI: Clean-up default_do_nmi()
> 
> Huang Ying (1):
>   x86, NMI: Add NMI symbol constants and rename memory parity to PCI
>     SERR
> 

FWIW, the series looks good to me. Thanks Don.

-- 
    Cyrill
