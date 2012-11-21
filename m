Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2KURX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:23:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52762 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545Ab2KURX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:23:57 -0500
Message-ID: <50AD0E22.3020807@zytor.com>
Date: Wed, 21 Nov 2012 09:23:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v3 01/12] x86, boot: move verify_cpu.S after 0x200
References: <1353482170-10160-1-git-send-email-yinghai@kernel.org> <1353482170-10160-2-git-send-email-yinghai@kernel.org>
In-Reply-To: <1353482170-10160-2-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2012 11:15 PM, Yinghai Lu wrote:
> We are short of space before 0x200 that is entry for startup_64.
>
> And we can not change startup_64 to other value --- ABI ?

Here you are saying "I don't understand how this works."  It is YOUR 
responsibility to find out and write a definite statement rather than 
leaving that to the reader, or expect the maintainer to edit this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

