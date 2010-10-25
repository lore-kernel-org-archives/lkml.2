Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab0JYWlE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:41:04 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49829 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab0JYWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:41:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TBTDFHBhjVcZe8o+Kbkz6Kh9T1/MqZv8YIYtYtugzxLNMKyBDnLJhs3HUkWE7pnjDZ
         CCclVoocR1mK/HGJ+J/lhjwDOUp2w71lWySLhyVilJ3saDKBHd7e8elQjz+lg3nmtMz5
         KgmozsItgjMt87hfnaXUGZI3YMy827mxAM9Cc=
Date: Tue, 26 Oct 2010 00:40:45 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Alon Ziv <alon@nolaviz.org>
Cc: Alon Ziv <alon+git@nolaviz.org>, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Export usb_serial_generic_write_room for use in
 modules
Message-ID: <20101025224045.GB26070@localhost>
References: <1287859409-13810-1-git-send-email-alon-git@nolaviz.org>
 <1287859409-13810-2-git-send-email-alon-git@nolaviz.org>
 <20101025112043.GB4046@localhost>
 <4CC5E131.9040408@nolaviz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC5E131.9040408@nolaviz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 09:57:37PM +0200, Alon Ziv wrote:
> Hi Johan,
> 
> On 10/25/2010 01:20 PM, you wrote:
> >> Any module using usb_serial_generic_write (which is already exported)
> >> had better use usb_serial_generic_write_room as well, or be prepared
> >> for failures.
> >
> > As I mentioned elsewhere, this description is a little misleading as any
> > driver can use the generic write_room implementation simply by not
> > overriding it (i.e. leaving the write_room field undefined).
> >
> > There is nothing wrong with exporting it, but it is currently only your
> > other patch that requires that. Could you perhaps just modify the patch
> > description?
> >
> Well... the latest changes (due to your review) removed even my driver's
> use of this function. So probably there is no need to export it (at
> least not yet).
> 
> If you prefer that I leave the export in place (and unused), I will
> clarify the patch description.

There's no need to export it unless it's got a use (and it's easily done
later should need arise).

I'm off for a week to UK (Embedded Linux Conference and some holidays)
with limited mail access from tomorrow so I'll have to get back to you
on your other mail when I'm back.

Thanks,
Johan
