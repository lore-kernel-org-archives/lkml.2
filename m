Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2DDV3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:29:31 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55076 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2DDV3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <201204042326.47683.rjw@sisk.pl>
References: <201204010836.30707.rjw@sisk.pl> <201204042326.47683.rjw@sisk.pl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Apr 2012 14:29:08 -0700
X-Google-Sender-Auth: tVQLwqEUJbB6fW6izaaK2TQrGHY
Message-ID: <CA+55aFysMfRdZOJcEEnbZhrfG7Eqqy-0uZw_SvR9P_eoEvhr-Q@mail.gmail.com>
Subject: Re: [GIT PULL] More power management updates for 3.4
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 2:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Given the lack of feedback and the fact that you don't seem to have pulled this,
> I wonder if there's anything wrong with the changes or am I simply supposed to
> queue them up for 3.5?

Actually, I was just a bit unhappy with it, and decided I wanted to
give it a second look, and then it just fell in between the cracks.

I still don't like the timing of that thing, but I saw no major reason
not to pull. So in it went,

                  Linus
