Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab2K2JEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:04:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2K2JEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:04:02 -0500
Message-ID: <50B724F9.7040504@redhat.com>
Date: Thu, 29 Nov 2012 10:03:53 +0100
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-acpi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Acpi deadlocks with 3.7.0-rc4
References: <50A513A8.9010404@redhat.com> <CA+55aFy7hxayPzr3MiV1xc0bvLcd+-7b52iA3CYhbPZuWXr9yA@mail.gmail.com> <50B64996.1010709@redhat.com> <6072715.FoXSX1UJhO@vostro.rjw.lan>
In-Reply-To: <6072715.FoXSX1UJhO@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 28.11.2012 21:31, Rafael J. Wysocki napsal(a):
> On Wednesday, November 28, 2012 06:27:50 PM Zdenek Kabelac wrote:
>> Dne 28.11.2012 18:02, Linus Torvalds napsal(a):
>>> On Wed, Nov 28, 2012 at 8:21 AM, Zdenek Kabelac <zkabelac@redhat.com> wrote:
>>>>
>>>> I've opened  https://bugzilla.kernel.org/show_bug.cgi?id=51071
>>>> and attached picture there which is all I have.
>
> I wonder if you can try to apply the patch below and see if that makes any
> difference?
>

Yep - extended BZ with 2 new pictures - it's now crashing earlier within
the call of acpi_bus_get_device().

Zdenek

