Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab1EXXdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:33:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37517 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222Ab1EXXdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:33:50 -0400
Message-ID: <4DDC404D.8030505@zytor.com>
Date: Tue, 24 May 2011 16:33:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>, linux-scsi@vger.kernel.org,
        x86@kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] strict user copy checks on x86_64
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org> <4DDC232F.7080005@codeaurora.org>
In-Reply-To: <4DDC232F.7080005@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2011 02:29 PM, Stephen Boyd wrote:
> 
> It looks like 1, 2, 4, 6, and 7 got picked up. Should I resend the left
> over patches with appropriate acked-bys and tags? Would it be
> appropriate to push this through your tree?
> 

I was first going to think I'd pick up 8 and 9 in tip, but since 9 is
cross-architecture, Andrew's tree might be better.

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
