Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308Ab2CTP3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 11:29:00 -0400
Received: from [89.21.227.130] ([89.21.227.130]:42137 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760553Ab2CTP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 11:28:58 -0400
Message-ID: <4F68A236.3020003@itdev.co.uk>
Date: Tue, 20 Mar 2012 08:28:54 -0700
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Joonyoung Shim <jy0922.shim@samsung.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>,
        "Bowens, Alan" <Alan.Bowens@atmel.com>,
        "Tiwari, Atul" <Atul.Tiwari@atmel.com>
Subject: Re: [PATCH 18/20] Input: atmel_mxt_ts - read num messages, then all
 messages
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org> <1331640263-18935-19-git-send-email-djkurtz@chromium.org> <4F600355.5040605@samsung.com> <CAGS+omAPBSqs9BZQJ4dLYADE=htZdXOZkAne=eD_4GNLmoUv4w@mail.gmail.com>
In-Reply-To: <CAGS+omAPBSqs9BZQJ4dLYADE=htZdXOZkAne=eD_4GNLmoUv4w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kurtz wrote:
> On Wed, Mar 14, 2012 at 10:32 AM, Joonyoung Shim
> <jy0922.shim@samsung.com> wrote:
>> On 03/13/2012 09:04 PM, Daniel Kurtz wrote:
>>>
>>> Implement the MXT DMA method of reading messages.
>>> On an interrupt, the T44 report always contains the number of messages
>>> pending to be read.  So, read 1 byte from T44 in 1 i2c transaction, then
>>> read the N pending messages in a second transaction.
>>
>>
>> My mXT224 chip datasheet hasn't T44 object, is it updated?
>> If not, need to consider chips which doesn't have T44 object.
> 
> I could consider merging the use of T44 with the older 'check reportid
> 0xff' method, but would require help verifying the change with
> hardware that doesn't have T44.
> Does anybody out there have such hardware and is willing to test?

As he said, many maxtouch chips don't have T44. Although for chips that do
have T44, this would be a useful performance improvement.

What are you testing these patches on?

-- 
Nick Dyer
Software Engineer, ITDev Ltd
Hardware and Software Development Consultancy
Website: http://www.itdev.co.uk
