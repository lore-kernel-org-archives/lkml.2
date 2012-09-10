Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2IJSfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:35:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62494 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab2IJSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:35:11 -0400
Date: Mon, 10 Sep 2012 11:35:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Mike Waychison <mikew@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        khalid@gonehiking.org
Subject: Re: [PATCH v2] Add missing attributes to EFI variable attribute
 print out from sysfs
Message-ID: <20120910183506.GA25975@kroah.com>
References: <20120713174216.GA10445@hp.com>
 <CAGTjWtDyGrVuBXZzdDfbS961cRSQY7eZaEbb9E8HACk5-imiuQ@mail.gmail.com>
 <CAGTjWtAPKXfA7pOqWEfK2i_HbrtA6_w7+ezZyCo4NG1gBSEhwg@mail.gmail.com>
 <20120910180335.GA26021@kroah.com>
 <1347300789.4393.27.camel@lyra>
 <20120910181855.GA26404@kroah.com>
 <20120910182914.GA12076@ldl.usa.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910182914.GA12076@ldl.usa.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:29:14PM -0600, Khalid Aziz wrote:
> Some of the EFI variable attributes are missing from print out from
> /sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
> updates code to use pre-defined constants for masking current value
> of attributes.
> 
> Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Matthew Garrett <mjg@redhat.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/firmware/efivars.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 47408e8..d10c987 100644

Ah, so close...

What's with the "Re:" in the Subject"?

And what happened to the extra line that should be after the diffstat
and before the "diff --" line?

Third time's a charm?

greg k-h
