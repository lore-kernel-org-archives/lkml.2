Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1F2M3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:29:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57409 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1F2M3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:29:44 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.172.9]
In-Reply-To: <201106291359.14026.arnd@arndb.de>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <20110628164453.aa85c85c.rdunlap@xenotime.net> <BANLkTinDX9ETcqZ=hvSGaao2s=ZcM-JsAg@mail.gmail.com>
 <201106291359.14026.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 29 Jun 2011 15:29:23 +0300
Message-ID: <BANLkTiki0fZuVB4it1mOVbEYVZ8tUx0BTA@mail.gmail.com>
Subject: Re: [RFC 7/8] drivers: introduce rpmsg, a remote-processor messaging bus
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 2:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 29 June 2011, Ohad Ben-Cohen wrote:
>> On Wed, Jun 29, 2011 at 2:44 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >> +hardware accelerators, and therefore are often used to offload cpu-intensive
>> >
>> > prefer:                                                           CPU-
>> > throughout.
>>
>> Isn't that changing the meaning a bit ? Let's stick with the original
>> version, I think it's more clear.
>
> I think you misunderstood Randy, he meant you should do 's/cpu/CPU/' globally,

Oh, sorry, Randy. For some reason I thought you meant
s/cpu-intensive/CPU-throughout/ which didn't make a lot of sense to me
:)

s/cpu/CPU/ is of course nicer. thanks !

> The easiest way would be to replace it with 'or', as in
>
> ... remote cores (or hardware accelerators) may have ...

yeah, i'll do it, thanks.

It's a bit harder to get rid of the parentheses in the second
sentence, but I'll think of something too.

>> Probably the solution is to move 'source "drivers/virtio/Kconfig"'
>> into drivers/Kconfig, and remove all other instances.
>
> I think changing that would be good. However, you need to at least
> restructure the contents, or they will show up in the main driver menu.

I'll do that.

Thanks,
Ohad.
