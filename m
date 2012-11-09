Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2KILj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 06:39:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42558 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2KILjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 06:39:25 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1352460945.4387.7.camel@mattotaupa>
References: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com> <1352460945.4387.7.camel@mattotaupa>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 09 Nov 2012 12:39:05 +0100
To: Paul Menzel <pm.debian@googlemail.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>
CC: Linux Raid <linux-raid@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Message-ID: <ead47490-afc3-48f1-871f-ba421eac3dd5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, we cannot share those at this time since the hardwarenis not yet released.

Paul Menzel <pm.debian@googlemail.com> wrote:

>Dear Jim,
>
>
>Am Donnerstag, den 08.11.2012, 13:47 -0800 schrieb Jim Kukunas:
>> Optimize RAID6 recovery functions to take advantage of
>> the 256-bit YMM integer instructions introduced in AVX2.
>
>in my experiencing optimizations always have to be back up by
>benchmarks. Could you add those to the commit message please.
>
>> Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
>
>[…]
>
>
>Thanks,
>
>Paul

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
