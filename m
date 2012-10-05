Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2JEQVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:21:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41463 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650Ab2JEQVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:21:03 -0400
Date: Fri, 5 Oct 2012 09:20:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vineet.Gupta1@synopsys.com
Subject: Re: [PATCH v3] serial/8250/8250_early: Prevent rounding error in
 uartclk
Message-ID: <20121005162055.GA24092@kroah.com>
References: <1349267263-21683-1-git-send-email-abrodkin@synopsys.com>
 <20121003133740.69c9dbce@bob.linux.org.uk>
 <506C3532.4020400@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506C3532.4020400@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:53:06PM +0400, Alexey Brodkin wrote:
> On 03.10.2012 16:37, Alan Cox wrote:
> >>So the bug had been latent and it only showed up with such low cock
> >>rates.
> >
> >clock ?
> >
> >Perhaps Greg can tweak the description as it goes in - otherwise all
> >fine with me
> >
> Sorry for this.
> Essentially I meant "clock".
> May do another respin if needed.

Don't worry, I can edit it :)

greg k-h
