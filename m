Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2JUMD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:03:58 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:47072 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2JUMD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:03:56 -0400
Message-ID: <5083E4A8.3060501@ursulin.net>
Date: Sun, 21 Oct 2012 13:03:52 +0100
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Milan Broz <gmazyland@gmail.com>
CC: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Subject: Re: [dm-crypt] cryptsetup not working under 3.6 - regression from
 3.4?
References: <50830D33.5050807@ursulin.net> <5083C61C.5090807@gmail.com>
In-Reply-To: <5083C61C.5090807@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On 21/10/12 10:53, Milan Broz wrote:
> On 10/20/2012 10:44 PM, Tvrtko Ursulin wrote:
>> But I repeat, even if I load the required modules before hand things do
>> not work.
>
> I would say you are still missing some modules.
>
>> Kernel says this:
>>    device-mapper: table: 252:1: crypt: Error allocating crypto tfm
>>    device-mapper: ioctl: error adding target to table
>
> It complains about aes-cbc-essiv:sha256.
>
> It can be missing CBC od SHA256, but according the message I bet
> you have no "cbc" block cipher mode module compiled.
>
> Can you grep your final .config for CONFIG_CRYPTO_CBC and
> CONFIG_CRYPTO_SHA256 a paste it here?

I both working 3.4 and non-working 3.6 situation is the same:

CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_SHA256=m

Tvrtko

