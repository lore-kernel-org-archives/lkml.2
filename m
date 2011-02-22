Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1BVKHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 05:07:37 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:47164 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393Ab1BVKHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 05:07:36 -0500
Message-ID: <4D638AD6.5000505@metafoo.de>
Date: Tue, 22 Feb 2011 11:07:18 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Pali Rohar <pali.rohar@gmail.com>, Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/16] bq27x00: New Properties, fixes, bq27000 support
References: <1298356681-8317-1-git-send-email-lars@metafoo.de> <20110222094537.GA9709@oksana.dev.rtsoft.ru>
In-Reply-To: <20110222094537.GA9709@oksana.dev.rtsoft.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 10:45 AM, Anton Vorontsov wrote:
> Hello,
> 
> The patches look great!
> 
> On Tue, Feb 22, 2011 at 07:37:45AM +0100, Lars-Peter Clausen wrote:
> [...]
>> Lars-Peter Clausen (11):
>>   power_supply: Ignore -ENODATA errors when generating uevents
>>   power_suply: Initialize changed_work before calling device_add
> 
> Just a nit. There is a typo: suply should be supply.
> 
Woops. It's fixed now in my tree.

> No need to resend the patches, could you please just fix it
> in your tree?
> 
> Thanks!
> 

