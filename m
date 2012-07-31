Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2GaMsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:48:40 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54922 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab2GaMsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:48:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120727014650.GB17168@kroah.com>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com>
	<CA+5PVA6RFthz5vjf-0BOogocMEwVKn5uE2q1_frjPFoVeUPACg@mail.gmail.com>
	<20120727014650.GB17168@kroah.com>
Date: Tue, 31 Jul 2012 08:48:38 -0400
Message-ID: <CA+5PVA615qJ+uJaHqCtYC45DF0E6A-wg+0_=xn2eCM-4O1-XVg@mail.gmail.com>
Subject: Re: [vmw_vmci 00/11] VMCI for Linux
From: Josh Boyer <jwboyer@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 9:46 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jul 26, 2012 at 09:06:25PM -0400, Josh Boyer wrote:
>> On Thu, Jul 26, 2012 at 7:39 PM, Andrew Stiegmann (stieg)
>> <astiegmann@vmware.com> wrote:
>> >  drivers/misc/Kconfig                      |    1 +
>> >  drivers/misc/Makefile                     |    1 +
>> >  drivers/misc/vmw_vmci/Kconfig             |   16 +
>>
>> Is there a reason this isn't going into staging first?  The Hyper-V
>> drivers went through staging and that actually seemed to work fairly
>> well.
>
> Is there some reason you feel this should be in the staging tree now?
> Why?

Apologies for the delayed reply.  Was on vacation.

Mostly because this is only one of several drivers.  One that the
other drivers depend on, and I don't see those posted at all.  I'm
guessing we'll want changes that will cause those unposted drivers to
break.  It just seems to make sense to work on the API in staging
rather than slam it into drivers/misc/.

josh
