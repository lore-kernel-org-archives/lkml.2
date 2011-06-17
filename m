Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab1FQRK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:10:29 -0400
Received: from outmail009.snc4.facebook.com ([66.220.144.141]:39310 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112Ab1FQRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:10:25 -0400
Message-ID: <4DFB8AAF.1040002@fb.com>
Date: Fri, 17 Jun 2011 10:11:11 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] atomic: cleanup asm-generic atomic*.h inclusion
References: <20110615163115.773d072e.akpm@linux-foundation.org> <1308187784-3815-1-git-send-email-asharma@fb.com> <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com>
In-Reply-To: <BANLkTi=f2N+dO2nBLobM73jCg0U0QSqxNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/16/11 11:36 PM, Mike Frysinger wrote:
>
> i'm not sure this doesnt break things.  what tree exactly should i
> apply this patch to to verify things ?

I tested 3.0-rc2 + patch 1 + patch 2 + this patch.

  -Arun

