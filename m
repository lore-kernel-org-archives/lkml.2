Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1K1FLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 00:11:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab1K1FLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 00:11:07 -0500
Message-ID: <4ED317DB.30001@redhat.com>
Date: Mon, 28 Nov 2011 13:10:51 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Milan Broz <mbroz@redhat.com>
CC: device-mapper development <dm-devel@redhat.com>, NeilBrown <neilb@suse.de>,
        linux-raid@vger.kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 17/62] md: remove the second argument of k[un]map_atomic()
References: <1322371662-26166-1-git-send-email-amwang@redhat.com> <1322371662-26166-18-git-send-email-amwang@redhat.com> <20111127170013.20d180a9@notabene.brown> <4ED2108F.9000203@redhat.com>
In-Reply-To: <4ED2108F.9000203@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月27日 18:27, Milan Broz 写道:
> On 11/27/2011 07:00 AM, NeilBrown wrote:
>> On Sun, 27 Nov 2011 13:26:57 +0800 Cong Wang<amwang@redhat.com>  wrote:
>>
>>>
>>> Signed-off-by: Cong Wang<amwang@redhat.com>
>>
>> This and patch 57/62
>>
>>   Acked-by: NeilBrown<neilb@suse.de>
>>
>> thanks.
>>
>> Not sure why there are two separate patches to md/bitmap.c though...
>>
>> ... and I cannot offically 'ack' the dm-crypt.c parts of this as I'm not the
>>      maintainer.  'md' and 'dm' are separate systems in the same directory -
>>      confusing, isn't it :-(

That is my bad, I should fold the md parts into one... :-/
I will separate them correctly.

>
> These little walled gardens ... :)
>
> I hope I can ack that dm-crypt code, I added that chunk
> as part of loop-aes compatibility code.
> (Anyway Alasdair as dm maintainer should ack it too.)
>
> Acked-by: Milan Broz<mbroz@redhat.com>
>

Thanks, Neil and Milan!
