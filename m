Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1CQLrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1CQLrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:47:07 -0400
Message-ID: <4D81F4B3.4000004@redhat.com>
Date: Thu, 17 Mar 2011 08:46:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Greg KH <greg@kroah.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [ANNOUNCE] usbmon capture and parser script
References: <4D8102A9.9080202@redhat.com> <20110316194758.GA32557@kroah.com> <1300306845.1954.7.camel@t41.thuisdomein>
In-Reply-To: <1300306845.1954.7.camel@t41.thuisdomein>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-03-2011 17:20, Paul Bolle escreveu:
> On Wed, 2011-03-16 at 12:47 -0700, Greg KH wrote:
>> Very cool stuff.  You are away of:
>> 	http://vusb-analyzer.sourceforge.net/
>> right?

Thanks for pointing it. It seems very interesting.

Paul, 

On a quick test, it seems that it doesn't recognize the tcpdump file 
format (at least, it was not able to capture the dump files I got 
with the beagleboard). Adding support for it could be an interesting 
addition to your code. 

Btw, it seems that most of your work is focused on getting VMware logs.
Most USB adapters I handle are USB 2.0 only, and have very high 
bandwidth requirements (something like 40%-60% of the total bandwidth
available at the USB bus). It would be nice to be capable of using a
VM on some cases, but the last time I tested VMWare, kvm, etc, none 
of them were capable of properly support USB 2.0 with isoc data transfers.

Do you know if any of them are now capable of properly emulate USB 2.0
isoc transfers and give enough performance for the devices to actually
work with such high-bandwidth requirements?

>> I know you are doing this in console mode, but it looks close to the
>> same idea.

Yes, there are some similarities, although I think that the tools
complement each other.

Doing it via console is nice, as I can just use the serial interface of
the beagleboard to capture and parse data in real time.

An offline graphic analyser is interesting, especially when you need to
filter data and check event timings.

> Perhaps there should be some references to vusb-analyzer and similar
> tools in Documentation/usb/usbmon.txt (it now only mentions "usbdump"
> and "USBMon"). I remember looking for a tool like that (ie, a parser)
> for quite some time before stumbling onto vusb-analyzer.

Yeah, that seems a good idea to me too.

Cheers,
Mauro
