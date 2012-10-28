Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2J1Rse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 13:48:34 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60164 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499Ab2J1Rsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 13:48:33 -0400
Date: Sun, 28 Oct 2012 18:48:29 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Dmytro Milinevskyy <milinevskyy@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: ncm: correct endianess conversion
Message-ID: <20121028174829.GA3761@breakpoint.cc>
References: <1349729943-28995-1-git-send-email-milinevskyy@gmail.com>
 <20121024135834.GA4368@breakpoint.cc>
 <CAOUdcc9PwMg34n_W14ctgW2qqP1P+STan6JBH3uyO+y+jWZ0FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOUdcc9PwMg34n_W14ctgW2qqP1P+STan6JBH3uyO+y+jWZ0FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 06:30:02PM +0100, Dmytro Milinevskyy wrote:
> I was trying to keep 2 tabs but checkpatch didn't accept long line
> that's why I killed extra tab.

Then move them to the code section instead to initialize them in the
declaration section.

> >How does it work? Is the test on host side not strict enough?
> The host part(cdc_ncm) does not check this field.
> However I agree that at least on device side this should be corrected.
Good.

> Felipe, do you want me to send another patch or resend previous one
> with this correction?
If it hasn't been applied yet resend it.

> Thanks,

Sebastian
