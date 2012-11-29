Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2K2KNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:13:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2K2KNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:13:16 -0500
Message-ID: <50B73536.9060408@redhat.com>
Date: Thu, 29 Nov 2012 11:13:10 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
References: <50A513A8.9010404@redhat.com> <CA+55aFyLMmKuEvY6T2=vSHp_R4=ndqFEFNJsc3Axze2vYknKhg@mail.gmail.com> <50B63A04.9010901@redhat.com> <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com> <50B64996.1010709@redhat.com> <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com>
In-Reply-To: <CA+55aFz2p2_WUkhThjSDWAFVda6nujxX2YE_Qkqv1OVDChUEJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 28.11.2012 20:07, Linus Torvalds napsal(a):
> whole "prefix_node" pointer is bogus. It seems to have the value 0x1000.

Tested also this patch with this result:

https://bugzilla.kernel.org/show_bug.cgi?id=51071#c8

So while it's made it pass suspend/resume, it's not really usable
as docking then.

Zdenek

