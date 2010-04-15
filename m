Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0DOPUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:20:38 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:49709 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab0DOPUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:20:36 -0400
Message-ID: <cb42bb0ece8066ff0c4a1b69d11e8e56.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100414225608.GB12143@core.coreip.homeip.net>
References: <054d04d6a47f4ba368c8d75f8d8fb08f.squirrel@intranet.cs.nmsu.edu>
    <20100414225608.GB12143@core.coreip.homeip.net>
Date: Thu, 15 Apr 2010 09:20:31 -0600
Subject: Re: Handling macros with input devices
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: liux-input@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>,
       "Linux" <linux-kernel@vger.kernel.org>,
       "Linux USB" <linux-usb@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dmitry Torokhov wrote:
> Hi Rick,
>
> On Wed, Apr 14, 2010 at 12:19:30PM -0600, Rick L. Vinyard, Jr. wrote:
>> One of the sticking points I have with the G13 driver is that I'd like
>> it
>> to have support for macros. The reason I'd like to support macros is
>> that
>> the G13's raison d'etre is to allow the end user to customize the device
>> with their own macros.
>>
>> However, I've been looking around and I can't find any support for
>> macros
>> within the kernel.
>>
>> In particular, I have support for getkeycode and setkeycode ioctl's. I
>> was
>> thinking of supporting at least setkeycode to allow a standard way to
>> set
>> a one key macro. Supporting getkeycode and setting keybit are more
>> problematic.
>>
>> If someone has already brought this issue up I apologize, but I couldn't
>> find any discussion on the linux-input list relating to macros (at least
>> other than preprocessor macros).
>>
>> Any suggestions?
>>
>
> I consider macro handling to be userspace task. If needed, macro
> sequences can be injected back into the kernel via uinput devices to be
> consumed by regualar applications.

That clarifies alot. Thanks.

-- 

Rick

