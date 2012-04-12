Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966230Ab2DLWcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:32:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48362 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966195Ab2DLWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:32:03 -0400
Date: Thu, 12 Apr 2012 15:31:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412223159.GA11926@kroah.com>
References: <20120411231102.GA6404@kroah.com>
 <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com>
 <4F8733C1.7020305@ahsoftware.de>
 <20120412200606.GA23764@kroah.com>
 <4F873B5D.7010309@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F873B5D.7010309@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 10:30:21PM +0200, Alexander Holler wrote:
> Am 12.04.2012 22:06, schrieb Greg KH:
> >On Thu, Apr 12, 2012 at 09:57:53PM +0200, Alexander Holler wrote:
> >>Hello,
> >>
> >>Am 12.04.2012 02:29, schrieb Greg KH:
> >>
> >>>>is there any chance for this one to be included in this review cycle?
> >>>>
> >>>>http://www.spinics.net/lists/linux-wireless/msg87999.html
> >>>
> >>>Have you read Documentation/stable_kernel_rules.txt?  Based on that, I
> >>>don't think it can, yet, right?
> >>
> >>Hmm, after reading that, I think the text could need an update about
> >>how to submit patches written by others (which can already be found
> >>in the upstream tree).
> >>
> >>At least for me the text reads like only the authors can request
> >>inclusion of a patch into the stable tree.
> >
> >Patches are always welcome, but I think you will find the file already
> >describes this (hint, the first '-' line for the Procedure section
> >handles it).
> 
> That reads:
> 
> "- Send the patch, after verifying that it follows the above rules, to
>    stable@vger.kernel.org.  You must note the upstream commit ID in the
>    changelog of your submission, as well as the kernel version you wish
>    it to be applied to."
> 
> Maybe I'm a bit dumb, but what would be my changelog if the patch
> was written by someone else (and e.g. fixes something the author
> wasn't aware of or hasn't described)?

It would be identical to what is in Linus's tree today.

Export the patch from git, add the needed information to the comment
area (i.e. the git commit id and what kernel to apply it to) and send it
to that email address.

Or, even easier, just email the stable@ address the git commit id, and
the kernel version you want it applied to, and cc: the authors of the
patch and maintainers (on the signed-off-by: path).

Hope this helps,

greg k-h
