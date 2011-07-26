Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1GZSj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:39:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57094 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1GZSjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:39:25 -0400
Message-ID: <4E2F09BB.9060605@zytor.com>
Date: Tue, 26 Jul 2011 11:38:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <1311340547-7861-1-git-send-email-bp@amd64.org> <4E2F0068.1080001@redhat.com> <20110726181304.GD32536@aftab> <4E2F0498.8050005@zytor.com> <20110726183721.GF32536@aftab>
In-Reply-To: <20110726183721.GF32536@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 11:37 AM, Borislav Petkov wrote:
>>
>> I think the question was the width (and position) for the mask... i.e.
>> your [14:12] above which *is* magic.
> 
> Oh, that's easy: family 15h means bits [14:12] - those bits are used for
> I$ index generation.
> 

In other words, it's completely ad hoc.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

