Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0FOR3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:29:21 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:38833 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754298Ab0FOR3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:29:19 -0400
Message-ID: <4C17B84C.2080306@metafoo.de>
Date: Tue, 15 Jun 2010 19:28:44 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 23/26] power: Add JZ4740 battery driver.
References: <1275505397-16758-1-git-send-email-lars@metafoo.de> <1275505950-17334-7-git-send-email-lars@metafoo.de> <20100614155108.GA30552@oksana.dev.rtsoft.ru>
In-Reply-To: <20100614155108.GA30552@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov wrote:
> On Wed, Jun 02, 2010 at 09:12:29PM +0200, Lars-Peter Clausen wrote:
>   
>> This patch adds support for the battery voltage measurement part of the JZ4740
>> ADC unit.
>>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
>> ---
>>     
>
> Looks good. I see this is an RFC. Do you want me to apply it
> or there's a newer version to be submitted?
>
> Thanks,
>
>   
Hi. Thanks for taking a look at it.
I'll send a new series which has some minor cleanups for the battery
driver soon.

- Lars
