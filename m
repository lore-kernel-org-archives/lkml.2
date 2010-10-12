Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0JLQ4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:56:40 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:3284 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0JLQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:56:38 -0400
Message-ID: <4CB49346.50906@caviumnetworks.com>
Date: Tue, 12 Oct 2010 09:56:38 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Bernhard Walle <walle@corscience.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: Add Lanai board USB clock type
References: <1286791747-3151-1-git-send-email-walle@corscience.de> <4CB340F1.8020000@caviumnetworks.com> <4CB343DC.3050506@corscience.de> <4CB345C1.80709@caviumnetworks.com> <20101012155426.GA15238@kroah.com>
In-Reply-To: <20101012155426.GA15238@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Oct 2010 16:56:51.0537 (UTC) FILETIME=[7774BC10:01CB6A2E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 08:54 AM, Greg KH wrote:
> On Mon, Oct 11, 2010 at 10:13:37AM -0700, David Daney wrote:
>> On 10/11/2010 10:05 AM, Bernhard Walle wrote:
>>> Am 11.10.2010 18:53, schrieb David Daney:
>>>> On 10/11/2010 03:09 AM, Bernhard Walle wrote:
>>>>> Add the LANAI2 board to __cvmx_helper_board_usb_get_clock_type(). It
>>>>> also uses the USB_CLOCK_TYPE_CRYSTAL_12 clock.
>>>>>
>>>>> Signed-off-by: Bernhard Walle<walle@corscience.de>
>>>>> ---
>>>>>     drivers/staging/octeon/cvmx-helper-board.c |    1 +
>>>>>     1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> NAK.
>>>>
>>>> We don't currently support USB, so churning up this file doesn't help
>>>> anything.
>>>
>>> Well, agreed, but why not removing that code entirely then?
>>>
>>
>> That is the eventual plan.
>
> Why not do that now?
>

If others want do submit patches that do that, I would not object.  It 
is not currently my highest priority, so it may be a little while before 
I would get to it.

> Or add USB support to the driver, but don't leave it in the in-kernel
> driver and expect users to know that this is something they shouldn't be
> doing.
>
> Also, why aren't you going to support the USB devices?

I'm not sure where you got that idea.  What I said was "We don't 
currently support USB...", this doesn't mean that we wouldn't like to 
eventually have support for it merged.

> What's wrong with that?

Nothing.  You may recall that people are working on getting the driver 
merged:

http://marc.info/?l=linux-usb&m=128648942928513

The path of least resistance is to let that patch get merged first, and 
then submit the necessary glue to hook it up to OCTEON parts that 
support it.

David Daney
