Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2EBPO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 11:14:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53617 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266Ab2EBPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 11:14:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWa7fZsXXqch5HqQHjEz_HKHK3Oq7+2JPADqS2RwmMEOw@mail.gmail.com>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
 <1332135781-13695-18-git-send-email-yinghai@kernel.org> <CAErSpo4BZAf_i3ojXpg5WSFJ00G5i_vscVTu2va_Z3WJ0UHg=g@mail.gmail.com>
 <CAE9FiQURuG9z655PZgP-QR3w7LoSFondt4fhioO0whP=Q7+2rA@mail.gmail.com> <CAE9FiQWa7fZsXXqch5HqQHjEz_HKHK3Oq7+2JPADqS2RwmMEOw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 2 May 2012 09:14:02 -0600
Message-ID: <CAErSpo4Wmfsfw+iPs19BxF0y_CF6YjGg+p8OBJmwGuNBy3OrmA@mail.gmail.com>
Subject: Re: [PATCH -v11 17/30] resources: Add probe_resource()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 1:01 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, May 1, 2012 at 10:19 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Tue, May 1, 2012 at 4:57 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> I spent most of the day merging the patches up to this point, and they
>>> mostly make sense, but this one and the following ones are beyond my
>>> ken, so I gave up.
>>
>> ok, let me check if i could simplify that code more.

I suggested that you need a simpler *interface*, not just smaller
patches and more comments.  If the interfaces make sense and the code
is good, you don't need many comments.

> Split this one into two patches, and add more comments.
>
> Please check if it is readable.

Nope, sorry, I'm not putting my name on that.  If you still think
that's the only reasonable way to do it, you might be able to find
somebody else to merge the resource.c changes, and I'll just worry
about the drivers/pci parts.

Bjorn
