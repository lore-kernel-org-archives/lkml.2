Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2LMChc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:37:32 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:41021 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2LMCh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:37:27 -0500
Message-ID: <50C93F64.1090906@gmail.com>
Date: Wed, 12 Dec 2012 21:37:24 -0500
From: "draekko.dev" <draekko.dev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, trivial@kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: adds support for Novatek wireless mouse to usbhid
References: <CAKPZWXc55MWN3ajpvf0vLXP9KebFo17bGAmD8X=mavxyWJui1w@mail.gmail.com> <20121213015025.GA10991@kroah.com>
In-Reply-To: <20121213015025.GA10991@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I followed what was listed here
http://www.kernel.org/doc/Documentation/SubmittingPatches i won't be
resubmitting, i've already spent way too much time for a few lines of
code, I've already been through this with the Ubuntu guys amongst other
reasons. I can email you the file as attachment but that's the extent of
my involvement at this point.

Wishing you y'all a nice evening,
Ben

PS. Resubmitting this email as it for some reason was only sent to Greg.

On Wed, Dec 12, 2012 at 8:50 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, Dec 12, 2012 at 08:43:32PM -0500, Benoit Touchette wrote:
>> This patch adds support for the Novatek wireless mouse (device id
>> 0603:1602) to usbhid and fixes bug
>> https://bugzilla.kernel.org/show_bug.cgi?id=47031
>>
>> Reported-by: Benoit Touchette <draekko.dev@gmail.com>
>> Signed-off-by: Benoit Touchette <draekko.dev@gmail.com>
>>
>> ---
>>
>> --- linux-3.6.10/drivers/hid/hid-ids.h.orig    2012-12-10
>> 14:13:27.000000000 -0500
>> +++ linux-3.6.10/drivers/hid/hid-ids.h    2012-12-12 20:06:41.000000000 -0500
>
> Please use the scripts/get_maintainer.pl tool to send this patch to the
> correct people and mailing list.
>
> Also, your patch is line-wrapped, and can't be applied, you need to look
> into fixing your email client to not do this if you wish to get patches
> accepted.
>
> greg k-h
