Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab1CRRVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:21:48 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:51654 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab1CRRVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:21:40 -0400
Subject: Re: [ANNOUNCE] usbmon capture and parser script
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <greg@kroah.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Date: Fri, 18 Mar 2011 18:21:33 +0100
In-Reply-To: <4D81F4B3.4000004@redhat.com>
References: <4D8102A9.9080202@redhat.com> <20110316194758.GA32557@kroah.com>
	 <1300306845.1954.7.camel@t41.thuisdomein> <4D81F4B3.4000004@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.91 (2.91.91-2.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1300468899.1844.17.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 08:46 -0300, Mauro Carvalho Chehab wrote:
> On a quick test, it seems that it doesn't recognize the tcpdump file 
> format (at least, it was not able to capture the dump files I got 
> with the beagleboard). Adding support for it could be an interesting 
> addition to your code. 

Please note that Micah Dowty is the maintainer of vusb-analyzer. I
mostly cleaned, etc. its usbmon support (which was originally added by
Christoph Zimmermann). Anyway, you're always free to try to add support
for another file format. I must say that Micah was rather easy to work
with.

> Btw, it seems that most of your work is focused on getting VMware logs.

Micah had a vmware.com address last time I contacted him. That should
explain that focus.

> Do you know if any of them are now capable of properly emulate USB 2.0
> isoc transfers and give enough performance for the devices to actually
> work with such high-bandwidth requirements?

This is not something I know much about. I tried to use some digital
camera over USB with qemu without much success. Apparently qemu's USB
pass through has little chance of supporting high bandwidth USB devices.
See
http://lists.nongnu.org/archive/html/qemu-devel/2010-09/msg00017.html
for the - not very interesting - answer I got when I wanted to know more
about the problems of USB pass through in qemu.


Paul Bolle

