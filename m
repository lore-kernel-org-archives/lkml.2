Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021Ab0LOBiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:38:16 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:59936 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab0LOBiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:38:14 -0500
Message-ID: <4D081BF2.7000202@euromail.se>
Date: Wed, 15 Dec 2010 02:37:54 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <1292361672-2581-1-git-send-email-chase.douglas@canonical.com> <20101214221241.GA11519@core.coreip.homeip.net> <4D080A13.6050601@canonical.com>
In-Reply-To: <4D080A13.6050601@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PSgJa-000260-Ap.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PSgJa-000260-Ap d65f47302f0f249790cf1b85f05d41c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

>

> I gave this some more thought, and I was close to accepting it with
> documentation of the above restrictions. Then I thought of how the
> following two devices would be presented to userspace:
> 
> 1. A real MT device supporting up to 2 touches (e.g. a bamboo touch)
>   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
>   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
> 
> 2. A partial MT device using MT_TOOL_ENVELOPE (e.g. synaptics MT)
>   - ABS_{X,Y}, BTN_TOUCH, BTN_TOOL_FINGER, and BTN_TOOL_DOUBLETAP for ST
>   - ABS_MT_SLOT, ABS_MT_TRACKING_ID, ABS_MT_POSITION_{X,Y}, ABS_MT_TOOL_TYPE
> 
> Note that they are identical! The range of values for each axis would be
> identical too. The only way to tell the two apart would be to watch for
> the ABS_MT_TOOL_TYPE axis.


Ping has touched upon this subject as well, from the pen & touch perspective.
Generally, some ABS axes are actually enumerations, for which we have no direct
abstraction. If we had a way to declare the used values for such enumerations,
it would resolve these and possibly other issues.

Thanks,
Henrik

