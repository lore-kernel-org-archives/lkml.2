Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2AMPfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:35:08 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52330 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab2AMPfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:35:05 -0500
MIME-Version: 1.0
In-Reply-To: <4F0F1AFA.1080900@xenotime.net>
References: <20120109113633.24486.69758.stgit@localhost6.localdomain6>
	<20120109113641.24486.95511.stgit@localhost6.localdomain6>
	<4F0B6845.4080503@xenotime.net>
	<CAPiS6wCVo40tB40sXTzTt7RpVHJG_2wrYeP8L=ghin09WHftfg@mail.gmail.com>
	<4F0C75A5.6000000@xenotime.net>
	<CAPiS6wDYrryyPimun2N0xFCY3xCTDAS+tKKAmuZGjbSUjWpZGw@mail.gmail.com>
	<4F0DDF08.1000005@xenotime.net>
	<CAPiS6wCzm-ReJGLDcQN9vYEeVRVzcqSN_gfMHkjUqJ5x4WpnVA@mail.gmail.com>
	<4F0F1AFA.1080900@xenotime.net>
Date: Fri, 13 Jan 2012 17:35:04 +0200
Message-ID: <CAPiS6wAvG3Rde98dVoD+9dUm5ZjY6NUkXQ_JjFKtL9kNp3te9A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] menuconfig: add Home and End keys support for inputbox
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 7:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 01/12/2012 06:24 AM, Paulius Zaleckas wrote:
>> On Wed, Jan 11, 2012 at 9:12 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>> On 01/11/2012 01:21 AM, Paulius Zaleckas wrote:
>>>> On Tue, Jan 10, 2012 at 7:30 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>>> On 01/10/2012 03:50 AM, Paulius Zaleckas wrote:
>>>>>> On Tue, Jan 10, 2012 at 12:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>>>>>>> On 01/09/2012 03:36 AM, Paulius Zaleckas wrote:
>>>>>>>> Makes long string editing easier.
>>>>>>>>
>>>>>>>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> Does "default hostname" in the "General setup" menu use an inputbox?
>>>>>>
>>>>>> Yes, it does.
>>>>>>
>>>>>>> If so, I can't get Home and End keys to work for it.
>>>>>>
>>>>>> Strange. It works for me. Have you applied both patches?
>>>>>
>>>>> Yes, I have both patches applied.
>>>>
>>>> Ok this is really very strange, but I have made debug patch. See attachement.
>>>> It will print octal pressed key value just below the text field.
>>>>
>>>> From curses.h:
>>>> #define KEY_HOME      0406            /* home key */
>>>> #define KEY_END               0550            /* end key */
>>>>
>>>> Do you get the same values for Home and End keys? I do.
>>>
>>> All that I see in the inputbox when I use Home or End is:
>>>
>>> 033
>>>
>>> (ESCape key)
>>
>> Is it working with nconfig?
>
> When I try to edit "Default hostname" in nconfig and press Home or End keys,
> nconfig acts like I just pressed F7 and it gives me the "what config file name do I
> want to load" prompt.
>
>
>>> Could this have anything to do with me using xfce (xfce4)?
>>
>> I have xfce at home. Will try it later today.
>
> Thanks.

I have just tried with xfce daefault terminal and had no problems.
