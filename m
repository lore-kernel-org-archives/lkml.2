Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0LHRni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:43:38 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56454 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab0LHRnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:43:37 -0500
Message-ID: <4CFFC3C2.1080905@canonical.com>
Date: Wed, 08 Dec 2010 09:43:30 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1291721340-22652-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2010 03:29 AM, Henrik Rydberg wrote:
> Some touch devices are capable of detecting the envelope or hull
> of the touches, but not the touches themselves. This patch adds
> the MT_TOOL_ENVELOPE touch type to be used for such devices.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi all,
> 
> This patch represents an MT solution for those devices that can detect
> and report some effects of dual touch, but cannot report individual
> contacts. Synaptics and elantech are two examples. Having the drivers
> report the bounding rectangle of the touches is useful in userland,
> since the information makes it possible to implement zooming
> gestures. At the same time, it would be confusing to send these
> envelope points as fingers, since they clearly are not. As a remedy,
> introduce MT_TOOL_ENVELOPE, which tells applications that care about
> details that these are not real fingers, at the same time as it allows
> gesture applications based on MT data to function without
> modification.

Is it assumed that the envelop has only two touches comprising it? Or is
it any number of touches? If it's any number of touches, how does one
know how many touches it is?

How are the envelop shape and position determined?

I think the idea is good, I just don't have enough information to
understand how the tool type is supposed to be used. This has been an
issue with many evdev properties, so I'm hoping we can provide more
detailed documentation this time around :).

-- Chase
