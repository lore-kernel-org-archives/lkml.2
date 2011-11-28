Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1K1MAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:00:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab1K1MAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:00:01 -0500
Message-ID: <4ED37541.4040701@redhat.com>
Date: Mon, 28 Nov 2011 19:49:21 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 10/62] ata: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-11-git-send-email-amwang@redhat.com> <4ED35BFE.6080900@mvista.com> <4ED373C3.4050903@redhat.com>
In-Reply-To: <4ED373C3.4050903@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月28日 19:42, Cong Wang 写道:
> 于 2011年11月28日 18:01, Sergei Shtylyov 写道:
>> Hello.
>>
>> On 27-11-2011 9:26, Cong Wang wrote:
>>
>>> Signed-off-by: Cong Wang<amwang@redhat.com>
>>> ---
>>> drivers/ata/libata-sff.c | 8 ++++----
>>> 1 files changed, 4 insertions(+), 4 deletions(-)
>>
>> IMO, you should do this in a single patch, not piecemeal to keep the kernel bisectable.
>>
>
> Hi,
>
> Please see patch 01/62,
>
> https://lkml.org/lkml/2011/11/28/35
>
> So even without it, the kernel can still compile, just with some warnings.
>

Ah, no, sorry that I replied too quickly. We have to have at least 01/62
to compile.

Actually I did make the patches as a whole, but Andrew Morton prefers to
split them, so I make V2 of them.
