Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168Ab1FACGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 22:06:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36367 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab1FACGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 22:06:45 -0400
Message-ID: <4DE59E9E.5030802@zytor.com>
Date: Tue, 31 May 2011 19:06:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Some x86, asm cleanups
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
In-Reply-To: <1306873314-32523-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 01:21 PM, Borislav Petkov wrote:
> Hi,
> 
> here are a couple of asm cleanups. I hope I don't break some esoteric
> gas version with them. They survived booting into kvm and on a couple of
> different machines so I might get lucky.
> 
> Suggestions welcome, as always.
> 
> Thanks.

Any way you can try them out on the gas version from hell[TM], a.k.a. 2.16?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

