Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab2JKVwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 17:52:08 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:49753 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759414Ab2JKVwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 17:52:03 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgWfAIQ+d1BV5h1yPGdsb2JhbABEDoo+tAcEfRkBAQEBHxkNJ4IgAQEEATocKAsIAxguFCUKGgEJiAcKuVgUizMvA4UOYAOVbIVyjHE9
X-IronPort-AV: E=Sophos;i="4.80,574,1344204000"; 
   d="scan'208";a="204235969"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 11 Oct 2012 23:54:39 +0200
To: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121011215439.GA505@polaris.bitmath.org>
References: <20121010203118.GA792@polaris.bitmath.org>
 <20121010203459.20663.qmail@stuge.se>
 <20121011054403.GA1680@polaris.bitmath.org>
 <20121011065033.2168.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011065033.2168.qmail@stuge.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 08:50:33AM +0200, Peter Stuge wrote:
> Henrik Rydberg wrote:
> > > What is the programming cable and software that uses it?
> > 
> > The programmer is impact, using libusbx-1.0.14-1.
> 
> Do you know for a fact that your version calls libusb-1.0? Did you
> establish this with e.g. strace? ISE 11.1 impact uses only libusb.so,
> ie. libusb-0.1.

I modified libusbx during testing, and yes, it is really used.

> > The patch is pretty generic, so I am suprised the problem has not
> > shown up earlier.
> 
> There are several explanations. There is clearly a problem with Hans'
> patch(es) for some cases, but those are perhaps not so common.

As it turned out, all cases of large bulk transfers, so I guess 3.6
has not been that widely tested yet. ;-)

> I've reviewed Hans' patch that he added to libusbx and which is in
> libusbx-1.0.14, but I am not sure that it is correct, which is why
> I haven't included it in libusb yet.

I looked at it for a while, it does seem correct.

Thanks,
Henrik
