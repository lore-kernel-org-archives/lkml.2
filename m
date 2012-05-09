Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707Ab2EISKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:10:03 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47789 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2EISKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:10:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120509053502.GA30063@polaris.bitmath.org>
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
	<CAN+gG=HqGmf77P6=7RMFT_Ez7Ysp4ZVJ6skfAoDcZ7JN1JtYnw@mail.gmail.com>
	<20120506182835.GA12221@polaris.bitmath.org>
	<20120508060221.GA15925@yabbi.bne.redhat.com>
	<20120508184052.GA23748@polaris.bitmath.org>
	<20120508235219.GA4067@yabbi.redhat.com>
	<20120509053502.GA30063@polaris.bitmath.org>
Date: Wed, 9 May 2012 11:10:00 -0700
Message-ID: <CAF8JNhLv3iNgnhzrjEXSFRKUU4hAUKnz1dAadP1FnMxPtu90Sg@mail.gmail.com>
Subject: Re: [RFC] Input: MT - Include win8 support
From: Ping Cheng <pinglinux@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, chatty@enac.fr, chasedouglas@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 8, 2012 at 10:35 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>
> > > > > Looking at the figure, it is clear that the MT model has two
> > > > > centers,
> > > > > one for each ellipse. Thus, center is not discriminating
> > > > > enough. Perhaps ABS_MT_OUTER_X/Y is more appropriate, then?
> > > >
> > > > ABS_MT_OUTER_CENTER
> > >
> > > I appreciate the suggestion, but along two-word combinations,
> > > ABS_MT_OUTER_POSITION would integrate better with existing names. Both
> > > seem awfully long, though.
> >
> > problem I see with "outer position" is that I'd associate it with the
> > top/left position of whatever "outer" is, not with the center of said
> > envelope. that's why I'd argue that "center" should be somewhere in the
> > name.
>
> Top-left does not apply to an ellipse, so that argument makes little
> sense for someone looking only at the MT protocol. Given that position
> is the actual protocol name for the center of the touching ellipse,
> there is hardly any doubt what it means in this context.
>
> How about ABS_MT_TOOL_X/Y?

I am ok if we use any one of the suggested terms. The term is non
technical per se. Readers will have to look into the spec to
understand what exactly it means. But, I'd choose ABS_MT_CENTER_X/Y if
we can only pick one from the suggested ones.

MT_TOOL_X/Y is unique. But, it introduces TOOL to the term. That makes
me think about MT_TOOL_FINGER and MT_TOOL_PEN, which are irrelevant to
this context.

Ping
