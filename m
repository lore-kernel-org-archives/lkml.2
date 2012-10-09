Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab2JIQut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:50:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:53067 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab2JIQuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:50:46 -0400
Date: Tue, 9 Oct 2012 12:38:59 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] ACPI: add drivers_autoprobe in struct acpi_device
Message-ID: <20121009163858.GA25276@phenom.dumpdata.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com>
 <1349305214-3241-1-git-send-email-yinghai@kernel.org>
 <1349305214-3241-2-git-send-email-yinghai@kernel.org>
 <CACJDEmoeD+XwjGnA2WwkeJ5TrsaXfgw+mZHPDcX0+7QZ9_80SA@mail.gmail.com>
 <CAE9FiQVFY1M65smht2vkAAR3nvH+SMUe2NteBvUyZzqabARV2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVFY1M65smht2vkAAR3nvH+SMUe2NteBvUyZzqabARV2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 08:15:44AM -0700, Yinghai Lu wrote:
> On Thu, Oct 4, 2012 at 6:03 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
> > On Wed, Oct 3, 2012 at 7:00 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> To use to control the delay attach driver for acpi_device.
> >
> > <blinks>
> > I am not sure what this says. Can you please explain how it controls
> > the delaying of
> > attaching drivers?
> >>
> >> Will use bus notifier to toggle this bits when needed.
> >
> > Will use ..? In a subsequent patch? Which patch? And when is this
> > needed? Is there a patch that needs this?
> 
> please check patch 0-4 as a whole.

But that is not how one is going to read the source code in a year or
so. In a year I will look at at file, run 'git gui annotate <file>' and
from the lines can find the corresponding patch. Then from there on
continue on to get the other patches.

The point is that in a year or so, the writeup you did will be
forgotten. If it is part of the _patch_ then it will not be.

If that means the git commit description has a couple of paragraphs
- that is OK.
> 
> Yinghai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
