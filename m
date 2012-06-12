Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2FLVFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:05:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45850 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab2FLVFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:05:47 -0400
Message-ID: <4FD7AF24.8080607@zytor.com>
Date: Tue, 12 Jun 2012 14:05:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Brandon Falk <bfalk@gamozolabs.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [question] x86/x86_64 boot process
References: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com>
In-Reply-To: <CAK9+cJX9GHjToKbOqqmink5Kr-9y3ZhQPC8M8rcL70rWbbYVYw@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 01:49 PM, Brandon Falk wrote:
> Greetings. Please CC me on any responses as I do not subscribe to the list.
> 
> I'm currently working on a very very small boot loader. Currently it
> uses BIOS int 0x13 to load up the 'setup' segments to 0x9000:0x0000. I
> jump to this location, set up the kernel options, and then jump to
> 0x9020:0x0000. Everything goes great. However, I get the message 'No
> setup signature found...'. I'm assuming this is due to not loading up
> the protected-mode code. I'm slightly confused as to how the protected
> mode code is to be loaded. As my 'bzImage' is 2.6MB, I would need to
> raise the A20 line to possibly load this up. Does the kernel assist in
> this process at all? Should I set up a code32_start routine for my
> code to load up the kernel? Once I'm in protected mode, how will I
> even access the medium that the kernel is loaded from without creating
> a driver?
> 
> Currently the medium is a floppy image loaded in VMWare. It's a 64-bit
> system. I'm just looking to be pointed in the right direction for the
> next step (and if my current steps are valid for Protocol 2.10).
> 
> Here's the current code (the code is manually overwritten onto the
> bzImage, however only the code... the headers are left intact on the
> bzImage):
> 

Please read Documentation/x86/boot.txt.

	-hpa

