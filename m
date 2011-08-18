Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1HRG4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 02:56:05 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59401 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1HRG4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 02:56:01 -0400
Message-ID: <4E4CB740.5020301@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 14:54:56 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: JJ Ding <jj_ding@emc.com.tw>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 4/6] Input: elantech - work around EC buffer
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw> <4E4C81EB.7040303@cn.fujitsu.com> <8739gz43lp.fsf@emc.com.tw>
In-Reply-To: <8739gz43lp.fsf@emc.com.tw>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 14:54:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 14:54:44,
	Serialize complete at 2011-08-18 14:54:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 02:48 PM, JJ Ding wrote:
> Hi Wanlong Gao,
>
> On Thu, 18 Aug 2011 11:07:23 +0800, Wanlong Gao<gaowanlong@cn.fujitsu.com>  wrote:
>> On 08/18/2011 09:57 AM, JJ Ding wrote:
>>>
>>>    	return PSMOUSE_FULL_PACKET;
>>> +
>>> + bad_packet:
>> You may introduce space here.
> Sorry, I am following you here.
> Do you want me to add one more line below bad_packet:,
> or you want me to remove the space before bad_packet?
>
> I keep that space to make the goto tags look consistent with other
> places in this file.
>
> Should I remove all starting spaces in goto tags in the file?
>
> Thanks,
>
> jj

aha, I see that some with space but some without.
Now, I'm not sure....;)

Thanks
-Wanlong Gao
>
>>> +	memmove(psmouse->packet, psmouse->packet + 1, psmouse->pktsize - 1);
>>> +	psmouse->pktcnt--;
>>> +	return PSMOUSE_GOOD_DATA;
>>>    }
>>>
>>>    /*
>>
>>
>> --
>> Thanks
>> Wanlong Gao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

