Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965408Ab2B1Lgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 06:36:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61052 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab2B1Lgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 06:36:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mans.rullgard@linaro.org designates 10.52.73.98 as permitted sender) smtp.mail=mans.rullgard@linaro.org
MIME-Version: 1.0
In-Reply-To: <4F4C9F85.1060907@arm.com>
References: <20120228010511.GA8453@kroah.com>
	<20120228010430.467184125@linuxfoundation.org>
	<CAG5Tg6VZR7fmbmxtn=8JXzmDhbJZftryDujtquWfFWJXSEs3LA@mail.gmail.com>
	<20120228084415.GA9280@flint.arm.linux.org.uk>
	<4F4C9F85.1060907@arm.com>
Date: Tue, 28 Feb 2012 11:36:34 +0000
Message-ID: <CAG5Tg6XSAZB6n+Bi5Cb+1X7Q_QAO4pTeiUj3DrD0rA10Ab9Ufw@mail.gmail.com>
Subject: Re: [ 12/72] ARM: 7326/2: PL330: fix null pointer dereference in pl330_chan_ctrl()
From: Mans Rullgard <mans.rullgard@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 February 2012 09:33, Javi Merino <javi.merino@arm.com> wrote:
> On 28/02/12 08:44, Russell King wrote:
>> On Tue, Feb 28, 2012 at 02:29:14AM +0000, Mans Rullgard wrote:
>>> On 28 February 2012 01:04, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Javi Merino <javi.merino@arm.com>
>>>
>>> I'm pretty sure I wrote that patch...
>
>
> Yes, you are in the Signed-off-by and I asked you to submit it a couple
> of times.

I was away (at ELC and elsewhere) without decent net access at the time,
so thanks for doing the submission.

>> But if you don't submit it, or Javi doesn't include a From: line and
>> submits it instead, then this is what happens.
>
> I didn't know I could include a From: line but I thought Single-off-by
> meant something like authorship.
>
> Sorry for that,

Don't worry, it's a trivial patch not worth fretting about.

-- 
Mans Rullgard / mru
