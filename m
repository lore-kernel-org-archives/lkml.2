Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2HQAFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 20:05:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42009 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2HQAFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 20:05:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120816204638.GA4463@kroah.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
	<CACVXFVM_WY4v69jdQiG13B94rEPP1EzHXpetZRrTJwhmgT=S2w@mail.gmail.com>
	<20120816204638.GA4463@kroah.com>
Date: Fri, 17 Aug 2012 08:04:59 +0800
Message-ID: <CACVXFVPt_xAS5+SdRB4XY55yP6=qCWfzG+ZUmSjeLse6AQ2t5A@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/15] firmware loader: introduce cache/uncache firmware
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 4:46 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Ok, these look good to me, so I've applied the first 14 to the
> driver-core-next tree to get some testing by others.
>
> I didn't feel I could add the 15th patch without some acks from those
> developers, or at least someone who says "it works for me!".

OK, there is still one problem(double free in failure path) in the 15th patch,
and I will send a new version later and ask for comments from ath9k guys.

>
> Also, what about those other patches you reference in your footnotes
> above, what's the status of them?

There is only one patch in the reference below which need to be
merged, but it has nothing conflicted with these firmware loader 14
patches.

         http://marc.info/?l=linux-kernel&m=134323730805443&w=2

I think Linus will deal with it, :-)


Thanks,
--
Ming Lei
