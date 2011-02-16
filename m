Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1BPS5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 13:57:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60772 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab1BPS5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 13:57:31 -0500
Message-ID: <4D5C1DFD.5010108@zytor.com>
Date: Wed, 16 Feb 2011 10:57:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCHv2] Fix EDD3.0 data verification.
References: <20110203122948.GX14984@redhat.com> <20110208145301.GO14984@redhat.com> <20110216150933.GE14984@redhat.com>
In-Reply-To: <20110216150933.GE14984@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2011 07:09 AM, Gleb Natapov wrote:
> On Tue, Feb 08, 2011 at 04:53:01PM +0200, Gleb Natapov wrote:
>> Peter, ping.
>>
>> Is this version acceptable?
>>
> Ping?
> 

Yes, looks good... I'll try to pull it into the tree today.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

