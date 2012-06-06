Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2FFCpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 22:45:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46067 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab2FFCpB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 22:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <1338908377.2977.1.camel@lorien2>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
 <1338135226.2968.22.camel@lorien2> <20120531210800.GB2400@gmail.com>
 <1338565180.2618.9.camel@lorien2> <20120604213735.GA1858@gmail.com>
 <1338851529.16672.1.camel@lorien2> <CAK5ve-Km=+M2nDyadV3zNcJxUoHJi=qRS7zbNrS=EGF=6uHQNg@mail.gmail.com>
 <1338908377.2977.1.camel@lorien2>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 6 Jun 2012 10:44:40 +0800
X-Google-Sender-Auth: UxaYz96l57FI2a1qVKenX42Dk1I
Message-ID: <CAK5ve-L=qiEgwXVziV7+dAafMTB4En_pM_0grpmP04cuCta0DQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
To: shuahkhan@gmail.com
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 10:59 PM, Shuah Khan <shuahkhan@gmail.com> wrote:
> On Tue, 2012-06-05 at 11:05 +0800, Bryan Wu wrote:
>> On Tue, Jun 5, 2012 at 7:12 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
>> >
>> >>
>> >> Of course, I've made many tests with mixes of led_trigger_blink() and
>> >> led_trigger_blink_oneshot() calls, and they seems to work samelessly.
>> > Great.
>> >>
>> >> If you think that the patch is good I'd like to consider that for
>> >> integration, so I can repost a modified version of my can-trigger
>> >> patch on the linux-can mailing list.
>> >
>> > Sounds good to me.
>> >
>>
>> Hi Fabio,
>>
>> I'm going to apply the patch to my for-next branch. and Shuah, can I
>> add your ack to this patch?
>
> Bryan,
>
> Yes. You can add my ack to this patch.
>

OK， cool, already done.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
