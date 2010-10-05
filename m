Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0JEPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 11:35:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754426Ab0JEPfx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 11:35:53 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010050927450.2556@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
 <201010041300.15234.arnd@arndb.de> <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6>
 <201010051544.52269.rusty@rustcorp.com.au> <alpine.LFD.2.00.1010050927450.2556@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 08:34:52 -0700
Message-ID: <AANLkTino8StCF7OZvzxeFrs0a4JVnxRK-deJ4XUU41Ef@mail.gmail.com>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 12:30 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 5 Oct 2010, Rusty Russell wrote:
>
>> On Tue, 5 Oct 2010 09:13:38 am Thomas Gleixner wrote:
>> > The patch below cures it.
>>
>> Using module_mutex here is just lazy...  Here's 5c, go buy your own lock :)
>
> I'm lazy. :) My evil plan of sending a crap patch so it gets replaced
> by a nice one worked well :)

Can you test the one I sent out (the second one with the trivial
module unload fix)? My own testing would be pretty pointless, since I
don't use modules myself (I've compile-tested it, and it all looks
sane, but...)

                  Linus
