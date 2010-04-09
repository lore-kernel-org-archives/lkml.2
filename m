Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0DIST2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 14:19:28 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:53205 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab0DISTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 14:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wp5aB/RcUZlo+cpyW2m+ro7dASaJT3iHh7PZVjiIy5675F3nw0Pdgdj/hlJwAC1TJW
         WD6NqmPTZw+IfmKOxbDYYqE6Yl5vs5LwVKuns3/pQJA2j+2kPuZ0ylLRXKxpug6+eHOi
         EPftXrkhytIXceEaFJk8nUcebIJ+SiA3PuRxU=
MIME-Version: 1.0
In-Reply-To: <20100409180942.GK30801@buzzloop.caiaq.de>
References: <m2n74fd948d1004081613n90408827s7c51ef572848fb1d@mail.gmail.com>
	 <Pine.LNX.4.44L0.1004091155570.1852-100000@iolanthe.rowland.org>
	 <20100409180942.GK30801@buzzloop.caiaq.de>
Date: Fri, 9 Apr 2010 19:19:22 +0100
Message-ID: <w2r74fd948d1004091119j9f33d8a6kc1824d9243abf38b@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2010 19:09, Daniel Mack <daniel@caiaq.de> wrote:
> On Fri, Apr 09, 2010 at 12:01:27PM -0400, Alan Stern wrote:
>> On Fri, 9 Apr 2010, Pedro Ribeiro wrote:
>> > here is the output of the patch you sent me when the interference is triggered.
>> >
>> > The log is long, 1.3mb in size.
>>
>> I don't see anything suspicious.  The transfer_buffer addresses repeat
>> every 32 URBs, and the DMA addresses cycle almost entirely uniformly
>> from 0x20000000 to 0x23ffffff in units of 0x2000 (there are a few gaps
>> where the interval is a little bigger).
>
> The DMA pointers do indeed look sane. I wanted to take a deeper look at
> this and set up a 64bit system today. However, I fail to see the problem
> here. Pedro, how much RAM does your machine have installed?
>
> Daniel
>
>

It has 4 GB.

Pedro
