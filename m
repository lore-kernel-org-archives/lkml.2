Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab2B1JeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:34:16 -0500
Received: from service87.mimecast.com ([91.220.42.44]:37437 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2B1JeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:34:13 -0500
Message-ID: <4F4C9F85.1060907@arm.com>
Date: Tue, 28 Feb 2012 09:33:57 +0000
From: Javi Merino <javi.merino@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
CC: Mans Rullgard <mans.rullgard@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [ 12/72] ARM: 7326/2: PL330: fix null pointer dereference in
 pl330_chan_ctrl()
References: <20120228010511.GA8453@kroah.com> <20120228010430.467184125@linuxfoundation.org> <CAG5Tg6VZR7fmbmxtn=8JXzmDhbJZftryDujtquWfFWJXSEs3LA@mail.gmail.com> <20120228084415.GA9280@flint.arm.linux.org.uk>
In-Reply-To: <20120228084415.GA9280@flint.arm.linux.org.uk>
X-OriginalArrivalTime: 28 Feb 2012 09:34:19.0378 (UTC) FILETIME=[2554CD20:01CCF5FC]
X-MC-Unique: 112022809340908101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/12 08:44, Russell King wrote:
> On Tue, Feb 28, 2012 at 02:29:14AM +0000, Mans Rullgard wrote:
>> On 28 February 2012 01:04, Greg KH <gregkh@linuxfoundation.org> wrote:
>>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Javi Merino <javi.merino@arm.com>
>>
>> I'm pretty sure I wrote that patch...


Yes, you are in the Signed-off-by and I asked you to submit it a couple
of times.

> But if you don't submit it, or Javi doesn't include a From: line and
> submits it instead, then this is what happens.

I didn't know I could include a From: line but I thought Single-off-by
meant something like authorship.

Sorry for that,
Javi


