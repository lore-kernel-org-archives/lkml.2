Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab2HHEuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 00:50:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33819 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2HHEuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 00:50:03 -0400
MIME-Version: 1.0
X-Originating-IP: [202.62.83.106]
In-Reply-To: <5020F119.80900@suse.cz>
References: <CANYdXnqCY+Uc=ROvQHv4kRe-g2zoEjfpzV0P83exfXYm-qCBaA@mail.gmail.com>
	<1344327969.20004.2.camel@localhost>
	<5020DB0B.8070103@suse.cz>
	<CANYdXnq1HVpLFZBND=2HextPXCLC5SkewsAqZFhY0KWzWi+rCw@mail.gmail.com>
	<5020F119.80900@suse.cz>
Date: Wed, 8 Aug 2012 10:20:02 +0530
Message-ID: <CANYdXnp3pO8S7J7nJipf7agpF651ZRFWXJhCE6rbjSizz4_+tA@mail.gmail.com>
Subject: Re: A question on serial driver
From: Shashidhar Hiremath <shashidharh@vayavyalabs.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dan Luedtke <mail@danrl.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks guys, got it to work. the receive interrupt was somehow getting disabled.

On Tue, Aug 7, 2012 at 4:12 PM, Jiri Slaby <jslaby@suse.cz> wrote:
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> On 08/07/2012 11:51 AM, Shashidhar Hiremath wrote:
>> the code is a bit unclean to send directly.
>
> Whatever, just send it out. Otherwise sorry, you are on your own.
>
> regards,
> --
> js
> suse labs



-- 
regards,
Shashidhar Hiremath
