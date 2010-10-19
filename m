Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab0JSFe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:34:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35790 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0JSFe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OM9xASLQ0Q4itjIfFR720BRv+SwEMAuWqsKJsti2IrCVLxIT/9PyXCBvxBKIs8sc3Q
         h5dU/6wXF38LktNNt9pVToyIbV3hLibf45cL8AV49uuAVdS3+UFUvRRDJLAny6J4yqYw
         KcH2weKSiDQC1VHGobLRo1dmIsQKJvSt34d74=
MIME-Version: 1.0
In-Reply-To: <20101019142640.44c87807.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101018021126.GB8654@localhost>
	<1287389631.1997.9.camel@myhost>
	<20101018180919.3AF8.A69D9226@jp.fujitsu.com>
	<1287454058.2078.12.camel@myhost>
	<20101019115952.d922763b.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikw6NizBStoXVz8Br_LYvoLoofsOB+d6-FX2=Be@mail.gmail.com>
	<20101019142640.44c87807.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 19 Oct 2010 14:34:57 +0900
Message-ID: <AANLkTim7CCfrqMa0661WEGeeg-AwQzaWi6Yfdi70se3W@mail.gmail.com>
Subject: Re: oom_killer crash linux system
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        lKOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        figo1802 <figo1802@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 2:26 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 19 Oct 2010 14:23:29 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Tue, Oct 19, 2010 at 11:59 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> >
>> >  Does anyone have idea about file-mapped-but-not-on-LRU pages ?
>>
>> Isn't it possible some file pages are much sharable?
>> Please see the page_add_file_rmap.
>>

Absolutely you're right.
Today, I need sleep. :(
Sorry for the noise.


-- 
Kind regards,
Minchan Kim
