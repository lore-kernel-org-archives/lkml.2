Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1HBFcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 01:32:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56833 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab1HBFcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 01:32:11 -0400
Message-ID: <4E378BA0.7000905@cn.fujitsu.com>
Date: Tue, 02 Aug 2011 13:31:12 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Anirudh Ghayal <aghayal@codeaurora.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Amy Maloche <amaloche@codeaurora.org>
Subject: Re: [PATCH] input: misc: Add support for pm8xxx based vibrator driver
References: <1312258397-11039-1-git-send-email-aghayal@codeaurora.org> <4E378043.3080801@cn.fujitsu.com> <20110802051156.GA7372@core.coreip.homeip.net> <4E3788B6.4020104@cn.fujitsu.com> <20110802052622.GB7372@core.coreip.homeip.net>
In-Reply-To: <20110802052622.GB7372@core.coreip.homeip.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 13:31:12,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-02 13:31:13,
	Serialize complete at 2011-08-02 13:31:13
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 01:26 PM, Dmitry Torokhov wrote:
> On Tue, Aug 02, 2011 at 01:18:46PM +0800, Wanlong Gao wrote:
>> On 08/02/2011 01:11 PM, Dmitry Torokhov wrote:
>>> On Tue, Aug 02, 2011 at 12:42:43PM +0800, Wanlong Gao wrote:
>>>> On 08/02/2011 12:13 PM, Anirudh Ghayal wrote:
>>>>> +/*
>>>>> + * struct pm8xxx_vib - structure to hold vibrator data
>>>>> + * @vib_input_dev: input device supporting force feedback
>>>>> + * @vwork: work structure to set the vibration parameters
>>>> Anirudh,  It's should be @work?
>>>
>>> Looks like it, I can fix it up locally, no need to resubmit.
>>>
>>> BTW, please do not hesitate to add your Reviewed-by or Acked-by if you
>>> are mostly satisfied with the patch (sans a few minor issues that you
>>> should point out). I can't guarantee that I will always add your tags
>>> (depends on when I commit the patch to my one of my public branches) but
>>> I will try to do so.
>>>
>>> Thanks.
>>>
>> Sure, I see, thanks Dmitry.
>>
>
> So was this reviewed-by? ;)
Sure.
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Sorry. ;)

Thanks
Best Regards
Wanlong Gao
