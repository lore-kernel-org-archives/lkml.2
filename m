Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935391Ab2JXRwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:52:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58874 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935343Ab2JXRw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:52:29 -0400
Date: Wed, 24 Oct 2012 10:52:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vacek <neelx.g@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] efi: Build EFI stub with EFI-appropriate options
Message-ID: <20121024175225.GA27553@kroah.com>
References: <1343340000-7587-1-git-send-email-mjg@redhat.com>
 <CAA7rmPGL827cgT6hM8h_xhokEbTbTnrptoRekVByM7AcMdRUdw@mail.gmail.com>
 <20121018182831.GA30905@srcf.ucam.org>
 <CAA7rmPHSX+nOfQc-rs729g7ibkH5VwvsGkiOLLxX794CAgmYSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA7rmPHSX+nOfQc-rs729g7ibkH5VwvsGkiOLLxX794CAgmYSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 10:32:50PM +0200, Daniel Vacek wrote:
> On Thu, Oct 18, 2012 at 8:28 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > On Thu, Oct 18, 2012 at 08:18:51PM +0200, Daniel Vacek wrote:
> >
> >> s/CLFAGS/CFLAGS/
> >>
> >> should go to stable too?
> >
> > Crap. Yes. Feel free to send that.

Applied, thanks.

greg k-h
