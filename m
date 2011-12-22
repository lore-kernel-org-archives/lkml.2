Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1LVU71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:59:27 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46903 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945Ab1LVU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:59:25 -0500
X-Sasl-enc: 94ILx5hh2+OpsCAhV/AOg9YISeEAJHkGbmwHzqhw4HVN 1324587564
Date: Thu, 22 Dec 2011 12:58:37 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        linux-kernel@vger.kernel.org, pjones@redhat.com
Subject: Re: [GIT PULL] ibft fix for 3.2-rc6
Message-ID: <20111222205837.GA30956@kroah.com>
References: <20111215210538.GA12248@konrad-lan>
 <CAE9FiQXFgOU3c9Ej-B_sZfhs5sRN87xE93BtZoU2K=M6=_O9YA@mail.gmail.com>
 <20111216000716.GA14822@suse.de>
 <CAE9FiQWufpJ7LwNiBnpS9bR_Sk4e5=wNZp2NmKp117+i56h=Sg@mail.gmail.com>
 <CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXsnc5FqbhPaZLsFbZa1zz44M8k-9yP-ow814oPEEDhjQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 04:40:34PM -0800, Yinghai Lu wrote:
> On Thu, Dec 15, 2011 at 4:37 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, Dec 15, 2011 at 4:07 PM, Greg KH <gregkh@suse.de> wrote:
> >
> >> The patch as-is does not apply to 2.6.32, so I can't apply it there.  If
> >> you want it applied there, please provide the backport to the above
> >> mentioned email address.
> 
> please check back ported patch for 2.6.36 to 2.6.39

Thanks, but I don't think these kernel versions are maintained by anyone
anymore, sorry.

> We don't need to this one for 2.6.32, because EFI/ACPI ibft detecting
> is only added from 2.6.36.
> 
> but 2.6.32 base kernel still could take iscsi_ibft.c related changes
> in the patch, and ignore conflicts with iscs_ibft_find.c.
> but that will add new feature to 2.6.32. Not sure if stable tree
> should take that kind of change.

No it will not, sorry.

greg k-h
