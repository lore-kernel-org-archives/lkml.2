Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400Ab2FEDFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 23:05:45 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39501 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2FEDFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 23:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <1338851529.16672.1.camel@lorien2>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com>
 <1338135226.2968.22.camel@lorien2> <20120531210800.GB2400@gmail.com>
 <1338565180.2618.9.camel@lorien2> <20120604213735.GA1858@gmail.com> <1338851529.16672.1.camel@lorien2>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 5 Jun 2012 11:05:22 +0800
X-Google-Sender-Auth: 7Zhmvao4b62Zvobp3-7rdEMgwVU
Message-ID: <CAK5ve-Km=+M2nDyadV3zNcJxUoHJi=qRS7zbNrS=EGF=6uHQNg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] leds: add oneshot blink functions
To: shuahkhan@gmail.com
Cc: Fabio Baltieri <fabio.baltieri@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 7:12 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
>
>>
>> Of course, I've made many tests with mixes of led_trigger_blink() and
>> led_trigger_blink_oneshot() calls, and they seems to work samelessly.
> Great.
>>
>> If you think that the patch is good I'd like to consider that for
>> integration, so I can repost a modified version of my can-trigger
>> patch on the linux-can mailing list.
>
> Sounds good to me.
>

Hi Fabio,

I'm going to apply the patch to my for-next branch. and Shuah, can I
add your ack to this patch?

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
