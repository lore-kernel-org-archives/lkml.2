Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab2IDA7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 20:59:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57273 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2IDA7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 20:59:40 -0400
Message-ID: <50455277.40109@gmail.com>
Date: Tue, 04 Sep 2012 10:59:35 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: daley <daleydeng@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Two question about kernel global function declaration and directory
 layout
References: <5044CDAB.4000902@gmail.com>
In-Reply-To: <5044CDAB.4000902@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/12 01:32, daley wrote:
> hi, everyone, I'm a big fan of the kernel, I was always being attracted
> by its clean and intelligent design. I'm new to the mailing list and
> this is my first post. I want to ask two basic question about kernel
> which bother me a lot, I've googled a lot but nobody could give a
> suitable answer .
> 
> The first one is about global function declaration, I was confused about
> the usage of keyword "extern" before a global function which declared in
> the header file. for example,

It specifies that the function has external linkage, which is the
opposite of internal (static keyword) linkage. The default linkage for
functions in external, so the extern keyword is not technically
required, but many developers like to specify it explicitly. C linkage
is explained here:

  http://publications.gbdirect.co.uk/c_book/chapter4/linkage.html

> The second question is why not move the *sound* directory into the
> *drivers* directory or put bigger subsystem out of drivers, since there
> are more bigger subsystems(e.g. media, scsi) than sound?

This was discussed a couple of years back, but never happened. I'm not
sure what the reasons were. You can read through the discussion yourself
if you are so inclined. There is an email from Linus explaining some of
the historical reasons why the sound code is in sound/ and not
drivers/sound:

  http://lkml.indiana.edu/hypermail/linux/kernel/0805.2/3026.html

~Ryan


