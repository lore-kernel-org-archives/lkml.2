Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab2HEQSK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:18:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41562 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab2HEQSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:18:08 -0400
Message-ID: <501E9CB9.8080902@gmail.com>
Date: Sun, 05 Aug 2012 18:18:01 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org,
        GregKH <greg@kroah.com>
Subject: Re: [PATCH 1/2] onewire: w1-gpio: add ext_pullup_enable pin in platform
 data
References: <1343249670-14985-1-git-send-email-zonque@gmail.com> <20120730181238.GA23443@ioremap.net> <20120731005929.GP27847@sci.fi> <501778DA.5020107@gmail.com> <20120801165736.GQ27847@sci.fi>
In-Reply-To: <20120801165736.GQ27847@sci.fi>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.08.2012 18:57, Ville Syrjälä wrote:
> On Tue, Jul 31, 2012 at 08:19:06AM +0200, Daniel Mack wrote:
>> On 31.07.2012 02:59, Ville Syrjälä wrote:
>>> On Mon, Jul 30, 2012 at 10:12:39PM +0400, Evgeniy Polyakov wrote:
>>>> Hi
>>>>
>>>> Sorry for long delay
>>>> [resend with fixed Greg's address :)]
>>>>
>>>> On Wed, Jul 25, 2012 at 10:54:29PM +0200, Daniel Mack (zonque@gmail.com) wrote:
>>>>> In the process of porting boards to devicetree implemenation, we should
>>>>> keep information about external circuitry where they belong - the
>>>>> individual drivers.
>>>>>
>>>>> This patch adds a way to specify a GPIO to drive the (optional) external
>>>>> pull-up logic, rather than using a function pointer for that.
>>>>
>>>> I do not object against this patch, but I have rather limited knowledge
>>>> about gpio driver. Patch looks good, feel free to add my
>>>> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
>>>>
>>>> Greg, please pull it into your tree, if Ville does not object.
>>>
>>> No objections from me.
>>
>> I take this as an Acked-by:?
> 
> Sure, why not :)
> 
> Acked-by: Ville Syrjälä <syrjala@sci.fi>
> 

Greg, could you queue up these two patches somewhere?


Thanks,
Daniel
