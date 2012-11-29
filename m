Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2K2M07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:26:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab2K2M04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:26:56 -0500
Message-ID: <50B75488.3090904@redhat.com>
Date: Thu, 29 Nov 2012 13:26:48 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
References: <50A513A8.9010404@redhat.com> <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com> <50B73536.9060408@redhat.com> <2444442.WEaJk5cR6y@vostro.rjw.lan>
In-Reply-To: <2444442.WEaJk5cR6y@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 29.11.2012 11:59, Rafael J. Wysocki napsal(a):
> On Thursday, November 29, 2012 11:13:10 AM Zdenek Kabelac wrote:
>> Dne 28.11.2012 20:07, Linus Torvalds napsal(a):
>>> whole "prefix_node" pointer is bogus. It seems to have the value 0x1000.
>>
>> Tested also this patch with this result:
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=51071#c8
>>
>> So while it's made it pass suspend/resume, it's not really usable
>> as docking then.
>
> This just makes acpi_ns_lookup() always return acpi_gbl_root_node
> for things looked up by acpi_ns_get_node() as far as I can say.
>
> Hmm.
>
> If my theory correct, the patch below should catch the bug.  Can you please
> test it?
>

Ok now crashing right after 'undock' button press:

https://bugzilla.kernel.org/show_bug.cgi?id=51071#c10


Zdenek


