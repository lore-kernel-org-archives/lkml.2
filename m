Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0DNS1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 14:27:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:31052 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab0DNS1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rmBhkIj7prF3QVSJUKjiFYvZXsAF9TY6LMBNdOKZNHZ/PvfiW6UfKTWs8OMA4/REw+
         yaZekM54tDTDUR6/+fi/kI3AETHsqfvH94AEe1amYot0GEbcNlysuf8kZLu53Yb7Nhcp
         GR3PJgg3TTj71svLkBdhTHPYrHVKKtqJZumyg=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004141422181.1716-100000@iolanthe.rowland.org>
References: <n2k74fd948d1004141021r8815647cx2b74085fc37a27b2@mail.gmail.com>
	 <Pine.LNX.4.44L0.1004141422181.1716-100000@iolanthe.rowland.org>
Date: Wed, 14 Apr 2010 19:27:42 +0100
Message-ID: <v2x74fd948d1004141127uda643cb2kf291fbaf3f2065b7@mail.gmail.com>
Subject: Re: USB transfer_buffer allocations on 64bit systems
From: Pedro Ribeiro <pedrib@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Mack <daniel@caiaq.de>, USB list <linux-usb@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2010 19:23, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 14 Apr 2010, Pedro Ribeiro wrote:
>
>> The best way to trigger the issue is to connect a dib0700 based DVB
>> adapter. All you need is to connect it. Since it polls for the remote
>> control every 50 msec, it causes a constant interference. Beware that
>> on 2.6.34 this behaviour has been corrected. Other DVB adapters may
>> trigger the same issue if they also poll constatly for the rc.
>
> Your computer has two EHCI controllers, doesn't it?  Can you plug the
> DVB into a different USB bus from the audio device?  If you do, does
> the interference still occur?
>
> Alan Stern
>
>

It does not matter on which ports I plug into, even if in different
buses not sharing IRQ's.

Pedro
