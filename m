Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab2J3BUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:20:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37379 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2J3BUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <20121029230337.GA22444@kroah.com>
References: <508E002B.4090200@teksavvy.com>
	<20121029064643.GE574@1wt.eu>
	<508E913D.2080104@teksavvy.com>
	<1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
	<20121029144722.GA23217@jshin-Toonie>
	<20121029165823.GA6614@kroah.com>
	<508F0AA6.6010702@teksavvy.com>
	<20121029230337.GA22444@kroah.com>
Date: Mon, 29 Oct 2012 18:20:09 -0700
X-Google-Sender-Auth: 4IByAb4_k7hojeiX40rEE2Y4GRs
Message-ID: <CAE9FiQU7ChpDZmmnZGcTU-v9rCXk-VFvhbAhn7320zfrzw8VXA@mail.gmail.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
From: Yinghai Lu <yinghai@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Lord <kernel@teksavvy.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ben Hutchings <ben@decadent.org.uk>,
        Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 4:03 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 29, 2012 at 07:00:54PM -0400, Mark Lord wrote:
>> Both systems feel much more sluggish than usual with 3.4.16 running.
>> Reverted them both back to earlier kernels (3.4.9, 3.4.4-PAE),
>> and the usual responsive feel has returned.
>>
>> Vague, I know, but something bad happened in there somewhere.
>
> That's too vague for me to do anything with, sorry.  Bisection would be
> good if you can figure out how to measure this.

yes, at least you can post boot log of working kernel and not working kernel.
then we could figure out if there is any corner case is not handled or
uncovered.
