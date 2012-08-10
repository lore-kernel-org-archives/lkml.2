Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2HJIfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 04:35:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab2HJIff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 04:35:35 -0400
Message-ID: <5024C7EF.7090408@redhat.com>
Date: Fri, 10 Aug 2012 10:35:59 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] NULL dereference BUG in sch56xx_init()
References: <20120809125526.GA11926@localhost> <20120809144239.GA6604@roeck-us.net>
In-Reply-To: <20120809144239.GA6604@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/09/2012 04:42 PM, Guenter Roeck wrote:
> On Thu, Aug 09, 2012 at 08:55:26PM +0800, Fengguang Wu wrote:
>> Hi Guenter,
>>
>> This commit triggered an oops which can be fixed by the attached diff.
>> Should it be folded into the original one (preferable for me), or be
>> resent as a standalone patch?
>>
> I folded it into the original commit.
>
> Thanks a lot for the test and feedback!

Fengguang, good catch, thanks!

Guenter, 2 remarks:

1) The changing of the type of the address parameter of sch56xx_device_add is
    not necessary
2) A similar change is needed for the f71882fg, there the type of the address
    variable in f71882fg_init() needs to be changed to int too.

Regards,

Hans
