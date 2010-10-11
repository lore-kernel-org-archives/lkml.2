Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0JKRNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:13:39 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9452 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0JKRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:13:38 -0400
Message-ID: <4CB345C1.80709@caviumnetworks.com>
Date: Mon, 11 Oct 2010 10:13:37 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Bernhard Walle <walle@corscience.de>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: Add Lanai board USB clock type
References: <1286791747-3151-1-git-send-email-walle@corscience.de> <4CB340F1.8020000@caviumnetworks.com> <4CB343DC.3050506@corscience.de>
In-Reply-To: <4CB343DC.3050506@corscience.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Oct 2010 17:13:49.0964 (UTC) FILETIME=[AC129CC0:01CB6967]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2010 10:05 AM, Bernhard Walle wrote:
> Am 11.10.2010 18:53, schrieb David Daney:
>> On 10/11/2010 03:09 AM, Bernhard Walle wrote:
>>> Add the LANAI2 board to __cvmx_helper_board_usb_get_clock_type(). It
>>> also uses the USB_CLOCK_TYPE_CRYSTAL_12 clock.
>>>
>>> Signed-off-by: Bernhard Walle<walle@corscience.de>
>>> ---
>>>    drivers/staging/octeon/cvmx-helper-board.c |    1 +
>>>    1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> NAK.
>>
>> We don't currently support USB, so churning up this file doesn't help
>> anything.
>
> Well, agreed, but why not removing that code entirely then?
>

That is the eventual plan.

David Daney
