Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab0GPSHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:07:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48976 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756846Ab0GPSHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:07:08 -0400
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <1279280574.2905.18.camel@morgan.silverblock.net>
References: <201007152108.27175.PeterHuewe@gmx.de>
	<1279230200.7920.23.camel@morgan.silverblock.net>
	<AANLkTikFTK4KwxKgQqwIId3dPy5hf5X0WjsAYkE5pEd4@mail.gmail.com>
	<1279280574.2905.18.camel@morgan.silverblock.net>
Date: Fri, 16 Jul 2010 14:07:07 -0400
Message-ID: <AANLkTinqytzuGXJRakN45u1K91uN66Empk1_7FmdpOxT@mail.gmail.com>
Subject: Re: [PATCH 24/25] video/ivtv: Convert pci_table entries to 
	PCI_VDEVICE (if PCI_ANY_ID is used)
From: Jarod Wilson <jarod@wilsonet.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Peter Huewe <PeterHuewe@gmx.de>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ian Armstrong <ian@iarmst.demon.co.uk>,
        Douglas Schilling Landgraf <dougsland@redhat.com>,
        Steven Toth <stoth@kernellabs.com>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 7:42 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Thu, 2010-07-15 at 18:07 -0400, Jarod Wilson wrote:
>> On Thu, Jul 15, 2010 at 5:43 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> > On Thu, 2010-07-15 at 21:08 +0200, Peter Huewe wrote:
>> >> From: Peter Huewe <peterhuewe@gmx.de>
>
>> > a. PCI_ANY_ID indicates to the reader a wildcard match is being
>> > performed.  The PCI_VDEVICE() macro hides that to some degree.
>> >
>> > b. PCI_VENDOR_ID_ICOMP clearly indicates that ICOMP is a vendor.
>> > "ICOMP" alone does not hint to the reader that is stands for a company
>> > (the now defunct "Internext Compression, Inc.").
>>
>> Personally, I'm a fan of comments around things like this to describe
>> *exactly* what device(s) they're referring to.
>
> Something like this then for ivtv:
>
> /* Claim every iTVC15/CX23415 or CX23416 based PCI Subsystem ever made */
>
> ?

More or less. Though perhaps more succinctly, just:

/* All iTVC15/CX23415 and CX23416 based devices */

>>  Then ICOMP being all
>> alone without the prefix isn't really much of an issue (though it
>> could still be easily mistaken for something other than a pci vendor
>> id, I suppose).
>
> Probably not.  Another minor side effect is that it breaks a tag search
> for easily jumping to the definition to see the ID value.  "ICOMP" won't
> be in the tags file, but "PCI_VENDOR_ID_ICOMP" will be.

Hm. That's a fair point. I recall a time or three hunting for symbols
using cscope, and having a bitch of a time, because some of them were
obscured by macro magic.


-- 
Jarod Wilson
jarod@wilsonet.com
