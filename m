Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab1GSPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:25:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59435 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1GSPZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:25:38 -0400
Message-ID: <4E25A1E3.9080707@gmail.com>
Date: Tue, 19 Jul 2011 08:25:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ath: Unable to reset channel (2412 MHz), reset status -5
References: <4E252076.1050309@gmail.com>	<CAD2nsn12vOXv-msWR+GF7edz3Q26P-pb4H-SO4rf2RHjC7mG+w@mail.gmail.com>	<4E2525BA.4090902@gmail.com> <CAD2nsn3ifSMa_eFr2vQ0VVF9Ga-0VD3YB_beb28r+eoAHKv4kQ@mail.gmail.com>
In-Reply-To: <CAD2nsn3ifSMa_eFr2vQ0VVF9Ga-0VD3YB_beb28r+eoAHKv4kQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2011 11:46 PM, Mohammed Shafi wrote:
> On Tue, Jul 19, 2011 at 12:05 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> On 07/18/2011 11:25 PM, Mohammed Shafi wrote:
>>>
>>> On Tue, Jul 19, 2011 at 11:43 AM, Justin P. Mattock
>>> <justinmattock@gmail.com>    wrote:
>>>>
>>>> seems with the latest Mainline I am getting the ath9k carpping out after
>>>> a
>>>> while of streaming(dmesg below)..:
>>>> http://fpaste.org/D7wM/
>>>>
>>>> will try a bisect if I have the time..
>>>
>>> I will try to recreate here with 3.0.0-rc7-wl, we can get more
>>> information by ath9k debug=0xffffffff.
>>> thanks.
>>>
>>
>> cool!
>> seems to fire off randomly over here.
>
> I have got AR5416, will try with that.
>

I can try the bisect, but might take a while, since external 
activities(job). Seems this is just starting i.g. with
3.0.0-rc1 I never saw this, but with 3.0.0-rc7-00125-gf560f66
its making noise.

Justin P. Mattock
