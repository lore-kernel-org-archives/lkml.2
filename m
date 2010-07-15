Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890Ab0GOWHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:07:46 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34541 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934803Ab0GOWHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:07:40 -0400
MIME-Version: 1.0
X-Originating-IP: [66.187.234.200]
In-Reply-To: <1279230200.7920.23.camel@morgan.silverblock.net>
References: <201007152108.27175.PeterHuewe@gmx.de>
	<1279230200.7920.23.camel@morgan.silverblock.net>
Date: Thu, 15 Jul 2010 18:07:39 -0400
Message-ID: <AANLkTikFTK4KwxKgQqwIId3dPy5hf5X0WjsAYkE5pEd4@mail.gmail.com>
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

On Thu, Jul 15, 2010 at 5:43 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Thu, 2010-07-15 at 21:08 +0200, Peter Huewe wrote:
>> From: Peter Huewe <peterhuewe@gmx.de>
>>
>> This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
>> .subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
>> PCI_VDEVICE macro, and thus improves readability.
>
> Hi Peter,
>
> I have to disagree.  The patch may improve typesetting, but it degrades
> clarity and maintainability from my perspective.
>
> a. PCI_ANY_ID indicates to the reader a wildcard match is being
> performed.  The PCI_VDEVICE() macro hides that to some degree.
>
> b. PCI_VENDOR_ID_ICOMP clearly indicates that ICOMP is a vendor.
> "ICOMP" alone does not hint to the reader that is stands for a company
> (the now defunct "Internext Compression, Inc.").

Personally, I'm a fan of comments around things like this to describe
*exactly* what device(s) they're referring to. Then ICOMP being all
alone without the prefix isn't really much of an issue (though it
could still be easily mistaken for something other than a pci vendor
id, I suppose).

-- 
Jarod Wilson
jarod@wilsonet.com
