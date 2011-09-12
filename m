Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab1ILHXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:23:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41994 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1ILHXq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:23:46 -0400
MIME-Version: 1.0
In-Reply-To: <20110912065618.GA23340@elie>
References: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
	<20110912065618.GA23340@elie>
Date: Mon, 12 Sep 2011 03:23:43 -0400
Message-ID: <CAK82gMFdUy5Dm+FpkrjuEeP9W6BFfGL4U0h-FP8b6BmMHAH1Ww@mail.gmail.com>
Subject: Re: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26
From: trouble daemon <troubledaemon@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, aystarik@gmail.com, x86@kernel.org,
        586494@bugs.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 12, 2011 at 2:56 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Sorry we dropped the ball on this.  Dan, any news (e.g., do later
> kernels do any better)?  Alexey, any ideas for tracking this down?

No worries, not like these machines are useful for much beyond museum
pieces any more ;) Sorry about the pastebin.ca though, I didn't
realize that they were gone.

As for later kernels, I have no idea tbh. Currently they seem to run
flawless with noapic, so that is what I use when installing and
running them. I do know that the Debian Squeeze installer chokes if I
don't use noapic, however.

If you are interested in some closure, I suppose I could take a shot
at installing something a little more recent and see if I can get away
with removing noapic though. Just let me know what kernel source
(vanilla/deb sid/etc), version, or any particular .config options that
you would like me to test, and I can see about pasting the console
terminal output when running without noapic disabled. I won't use a
pastebin this time, I promise ;)
