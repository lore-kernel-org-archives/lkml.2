Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab2CUUya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:54:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46042 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2CUUy1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:54:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120321134725.222e9c07@nehalam.linuxnetplumber.net>
References: <4F69BE2E.7070903@t-online.de> <20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
 <CAErSpo67PEaZ6JuMUntWLfR8SUpQgZERD_cKV6rWd=FF0tZ6DQ@mail.gmail.com> <20120321134725.222e9c07@nehalam.linuxnetplumber.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 21 Mar 2012 14:54:05 -0600
Message-ID: <CAErSpo7J+9ZgXcqw4_+WjpNAW9oKNfRosDm7CusUjpnukO1m4Q@mail.gmail.com>
Subject: Re: [PATCH] sky2: override for PCI legacy power management
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 2:47 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Wed, 21 Mar 2012 14:22:01 -0600
> Bjorn Helgaas <bhelgaas@google.com> wrote:
>
>> On Wed, Mar 21, 2012 at 9:32 AM, Stephen Hemminger
>> <shemminger@vyatta.com> wrote:
>> > Some BIOS's don't setup power management correctly (what else is
>> > new) and don't allow use of PCI Express power control. Add a special
>> > exception module parameter to allow working around this issue.
>> > Based on slightly different patch by Knut Petersen.
>> >
>> > Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
>> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
>>
>> Is there a problem report URL you can include here?
>>
>> It looks like this requires a user to figure out that he might be
>> suffering from this problem, then use this module parameter to work
>> around it.  How would a user figure that out?  Can we do it
>> automatically to save him the trouble?
>
> I am not a power management expert. Looks like a BIOS issue where the
> BIOS has configured the device to disable power management but the
> user wants to override that value. There is no method to determine
> when the BIOS is broken versus when the BIOS setting is correct and
> we should follow what it says.

I'm not a power management expert either.  I was just wondering
whether the known broken BIOSes could be encoded in a blacklist or
something, because it looks like a case where a user might have to
request help or debug the problem again before discovering this flag.

Bjorn
