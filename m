Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab2AJQcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:32:03 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:57045 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756486Ab2AJQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:32:01 -0500
Message-ID: <4F0C75A5.6000000@xenotime.net>
Date: Tue, 10 Jan 2012 09:30:13 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paulius Zaleckas <paulius.zaleckas@gmail.com>
CC: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] menuconfig: add Home and End keys support for
 inputbox
References: <20120109113633.24486.69758.stgit@localhost6.localdomain6>	<20120109113641.24486.95511.stgit@localhost6.localdomain6>	<4F0B6845.4080503@xenotime.net> <CAPiS6wCVo40tB40sXTzTt7RpVHJG_2wrYeP8L=ghin09WHftfg@mail.gmail.com>
In-Reply-To: <CAPiS6wCVo40tB40sXTzTt7RpVHJG_2wrYeP8L=ghin09WHftfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2012 03:50 AM, Paulius Zaleckas wrote:
> On Tue, Jan 10, 2012 at 12:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> On 01/09/2012 03:36 AM, Paulius Zaleckas wrote:
>>> Makes long string editing easier.
>>>
>>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
>>
>> Hi,
>>
>> Does "default hostname" in the "General setup" menu use an inputbox?
> 
> Yes, it does.
> 
>> If so, I can't get Home and End keys to work for it.
> 
> Strange. It works for me. Have you applied both patches?

Yes, I have both patches applied.

>> If not, please tell me a field that uses an inputbox so that I can test it.


Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
