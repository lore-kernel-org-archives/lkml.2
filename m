Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0LJPLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:11:16 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:50449 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0LJPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:11:14 -0500
MIME-Version: 1.0
In-Reply-To: <4D01D6AF.6010202@euromail.se>
References: <1291936745-4973-1-git-send-email-rydberg@euromail.se>
	<20101209234920.GA14810@core.coreip.homeip.net>
	<4D01D6AF.6010202@euromail.se>
Date: Fri, 10 Dec 2010 09:11:13 -0600
Message-ID: <AANLkTin+b_04qcOcFmP+0tYHCibvHHearfFXZJAb4R5R@mail.gmail.com>
Subject: Re: [PATCH] input: mt: Identify pointer emulation contact
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 1:28 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
>>
>
>> So how do you propose userspace will use it? Obviously it will not help
>> old dumb (ST) applications and new smart applications should understand
>> MT protocol and thus do not need to pay much attention to ST events
>> anyway. Apparently you have some new dumb userspace in mind here?
>
>
> You are right, it is a dumb idea. Consider this one dropped.

If anyone is working on clickpad support, they may want to keep this
idea in mind.  I guess I mean working on clickpads and with simple ST
apps.

If user clicks with one finger, I think currently that user expects
dragging that one finger will move cursor still (click-and-drag).  I'd
think its more usable though to click with one finger and drag with
the other.  During this use case we need to switch pointer tracking
from one finger to the other.

Sending a new tracking ID is an easy way to inform apps about expected
jump in values during switch.  I thought of things like
BTN_TOOL_FINGER=0; sync; BTN_TOOL_FINGER=1 but that looks like tapping
is occurring.

Anyways, as you suggestion, this can be solved by forcing apps to
process MT events so not to big a deal long term.

Chris
