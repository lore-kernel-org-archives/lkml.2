Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2BXBIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:08:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab2BXBIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:08:15 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.180.14.73 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223225602.747c31df@pyramind.ukuu.org.uk>
References: <20120223133931.6227.89653.stgit@bob.linux.org.uk>
	<1330029747.20389.37.camel@pasglop>
	<20120223225602.747c31df@pyramind.ukuu.org.uk>
Date: Thu, 23 Feb 2012 20:08:14 -0500
Message-ID: <CA+5PVA5Z=hLt_FdhkHh9nrY+J-kEmG4AYm1T8Rq6kO9OWzdADg@mail.gmail.com>
Subject: Re: [PATCH] tty: the briq panel isn't a tty, make it use its own locking
From: Josh Boyer <jwboyer@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 5:56 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 24 Feb 2012 07:42:27 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
>
>> On Thu, 2012-02-23 at 13:39 +0000, Alan Cox wrote:
>> > From: Alan Cox <alan@linux.intel.com>
>> >
>> > The driver appears to be terminall broken, if nobody is maintaining it then
>> > perhaps it should go into staging and the out-tray.
>>
>> Hrm, I don't think anybody maintains it but I do have a BriQ somewhere
>> in storage, so I suppose I could pick it up, not that I need another
>> crap driver to deal with right now though...
>
> In which case can we just stuff it into the tree, or take the briq driver
> out into staging as this is the last blocker on tackling the tty_lock
> entirely in the tty layer

I'd vote for out to staging.  Don't rely on BenH to make sane decisions when
it comes to deprecating stuff nobody uses anymore.  I mean... he's only just
now dropping iSeries support.

josh
