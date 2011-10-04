Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab1JDPl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:41:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:60012 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab1JDPlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:41:25 -0400
Subject: Re: [PATCH 2/3] pci: Clamp pcie_set_readrq() when using
 "performance" settings
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jon Mason <mason@myri.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
In-Reply-To: <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
References: <1317653420-21404-3-git-send-email-mason@myri.com>
	 <CA+55aFyyx99Z4=x-Twp7JCpU=JHPzP8HRdLc4H3NOGHNQq9jCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 17:40:38 +0200
Message-ID: <1317742838.29415.217.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 13:56 -0700, Linus Torvalds wrote:
> On Mon, Oct 3, 2011 at 7:50 AM, Jon Mason <mason@myri.com> wrote:
> >
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Acked-by: Jon Mason <mason@myri.com>
> 
> You need to sign off on this one too, since you're passing it on.
> 
> Also, I'd *really* like some more acks/reviews on the series. Anybody?

Hopefully most of these patches only affect the "performance" setting
which is no longer the default.

But yes, more reviews are always welcome.

Cheers,
Ben.

>                     Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


