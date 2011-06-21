Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1FUWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:07:36 -0400
Received: from ozlabs.org ([203.10.76.45]:51094 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959Ab1FUWHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:07:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: module: sysfs - add 'uevent' file to allow coldplug
In-Reply-To: <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com>
References: <1308434431.1050.5.camel@mop> <8739j59zib.fsf@rustcorp.com.au> <BANLkTink8YTe=-Tr5Ax3epiFoFCfzcex7w@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 21 Jun 2011 11:23:05 +0930
Message-ID: <87boxshrwe.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011 13:20:00 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Mon, Jun 20, 2011 at 01:23, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Sun, 19 Jun 2011 00:00:29 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >> From: Kay Sievers <kay.sievers@vrfy.org>
> >> Subject: module: sysfs - add 'uevent' file to allow built-in coldplug
> >>
> >> Userspace wants to manage module parameters with udev rules.
> >> This currently only works for loaded modules, but not for
> >> built-in ones.
> >
> > I'm confused.  What does "manage" mean here?
> 
> Hook system management into module-load events, which might include
> changing module parameters in /sys/module/*/parameters/*, or at
> bootup/coldplug run it for built-in modules.
> 
> We do the same to set properties for buses, drivers or devices when they appear.

Sorry, that's another vague answer :(

udev already knows about module load, and the parameters are created at
that point; they are not *changed*.

What, *exactly* will this enable?  Don't use the word "hook" or
"management": both vague terms which assume I know what you're talking
about.  I don't.

Show me exactly what udev will now be able to do that it can't do now,
and how it will be used.  Preferably with examples.  Assume (correctly)
that I have only a vague idea what udev does.

Thanks,
Rusty.
