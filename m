Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0C2QIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 12:08:19 -0400
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:42221 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754045Ab0C2QIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 12:08:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=uKO9rpyAPKfow1eGD81hMKCU/iqcBFI8KC1UX7iRhyq0RUSGnCcvfP/w6TG7yY/gxkDn4IQwQVcE6BLTSzl0Cy70PcTVG6itDjkaDmAEKDoViPHzAh76w0JsV3M3kBz+;
Date: Mon, 29 Mar 2010 09:07:13 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hans de Goede <hdegoede@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100329090713.1317942b@jbarnes-piketon>
In-Reply-To: <20100329081834.GB27956@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
	<1269523063-30346-1-git-send-email-me@mortis.eu>
	<20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
	<20100325180347.GA2761@salidar.me.mortis.eu>
	<20100325181633.0313b8a5@lxorguk.ukuu.org.uk>
	<20100329081834.GB27956@salidar.me.mortis.eu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 10:18:34 +0200
Giel van Schijndel <me@mortis.eu> wrote:

> On Thu, Mar 25, 2010 at 06:16:33PM +0000, Alan Cox wrote:
> >> +			if (res->flags & IORESOURCE_MUXED)
> >> +				wake_up(&muxed_resource_wait);
> >>  			kfree(res);
> >>  			return;
> > 
> > And you'll want a
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> Yes, thanks.
> 
> Anyone specific I should mail to get this patch applied? I don't see any
> entry in MAINTAINERS for kernel/resource.c or include/linux/resource.h.

I can take it; sometimes Linus applies resource stuff directly though.

Can you resend with the appropriate s-o-bs etc?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
