Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0E1C2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:28:08 -0400
Received: from core.signal11.us ([64.251.29.136]:34106 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0E1C2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:28:06 -0400
Message-ID: <4BFF2A33.8060504@signal11.us>
Date: Thu, 27 May 2010 22:28:03 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [RFC] User Guide for Sysfs and libudev
References: <4BFAC0B0.2060701@signal11.us> <AANLkTikDHib2QiQ51cJztYGxORojxo5PEwOGXvS5vCJ1@mail.gmail.com>
In-Reply-To: <AANLkTikDHib2QiQ51cJztYGxORojxo5PEwOGXvS5vCJ1@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Thu May 27 22:28:04 2010
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4bff2a34243661561636219
X-DSPAM-Factors: 27,
	of, 0.01000,
	of, 0.01000,
	Received*ESMTP, 0.01000,
	Received*(c+76, 0.01000,
	From*<alan, 0.01000,
	User-Agent*Thunderbird, 0.01000,
	Received*[192.168.1.200]+(c, 0.01000,
	Received*core.signal11.us, 0.01000,
	Date*2010, 0.01000,
	From*Ott, 0.01000,
	Received*with, 0.01000,
	be, 0.01000,
	be, 0.01000,
	Received*id, 0.01000,
	Alan, 0.01000,
	Alan, 0.01000,
	Received*ESMTP+id, 0.01000,
	Received*76, 0.01000,
	Received*2010, 0.01000,
	From*Alan, 0.01000,
	From*Alan+Ott, 0.01000,
	Date*0400, 0.01000,
	User-Agent*2.0.0.23, 0.01000,
	User-Agent*2.0.0.23+(X11/20090817), 0.01000,
	for, 0.01000,
	for, 0.01000,
	I, 0.01000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, May 24, 2010 at 20:08, Alan Ott <alan@signal11.us> wrote:
>> The guide can be found here:
>>    http://www.signal11.us/oss/udev/
>>     
>
> Enumeration and monitoring should be in one example, I guess -- that's
> what people are supposed to do today.
Hi Kay,

The example .c file does do both in the same example. The document talks
about them separately, for simplicity, since the lead-in section
directly makes the case for enumeration. I added a section of text (see
below) which mentions this.
> Before starting to enumerate,
> software should subscribe to events. This makes the handle
> coldplug/hotplug properly, makes it handle duplicate events properly,
> and all other sorts of cases, which software should handle today.
>   
This makes sense. I've changed the example .c program so that it sets up
the monitoring interface before enumerating. I also added a section to
the document talking about the reason for doing this first. The new
section is the one between the second code block and the "Output" section.
> Also "change" is not necessarily a "property" change, it can be any
> event, that a device has changed its state, it will only in  a few
> cases be visible in /sys. The most prominent example is "media
> changed" event for SCSI devices, and we forward them to the block
> device. There will never change anything in /sys before or after the
> event.
>   
I've changed the text in the document appropriately.

Also, would you please give me some text which describes the "online"
and "offline" events? What types of devices do these come from? Are
there any other types of events which are not listed?

Thanks for reading my document, and thanks for your insightful comments.

Alan.


