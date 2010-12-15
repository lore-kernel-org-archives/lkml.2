Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0LOVIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:08:11 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40011 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0LOVII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:08:08 -0500
Message-ID: <4D092E34.8060002@canonical.com>
Date: Wed, 15 Dec 2010 16:08:04 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chris Bagwell <chris@cnpbagwell.com>
CC: Henrik Rydberg <rydberg@bitmath.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <4D0897F3.7040500@bitmath.org>	<4D08FD74.4060403@canonical.com> <AANLkTik4aS4mA_yrEDiG0QRxHx2pJ+KGGMKEWSDep1CB@mail.gmail.com>
In-Reply-To: <AANLkTik4aS4mA_yrEDiG0QRxHx2pJ+KGGMKEWSDep1CB@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 03:41 PM, Chris Bagwell wrote:
> I meant to mention: once your initial draft gets committed I would
> love to help update it some.  I specifically want to show two example
> usage.  1) touchpad as 1 to 3 touchs occur and show special
> considerations to ABS_* that apps should handle.  2) a touchscreen
> that supports a pen as well and show how tool change (finger to pen)
> should work.  For both those examples, it would be interesting to
> discuss how MT can be used concurrently (does pen in slot 0 and touch
> in slot 1 make sense for example).

This is the other main reason I wanted to make the document. Having a
place where best practices are detailed will help future driver writers
and hopefully reduce errors in evdev code usage. I'd love to see this
added to the document.

I do think that MT is complex enough that related documentation should
be in multi-touch-protocol.txt, though. Anywhere I discussed MT in
evdev-codes.txt I referred the reader to the other file. Henrik, does
that sound good to you?

> I think it will be invaluable to document this stuff for driver
> writers and apps but I'm not sure yet what level needs to be enforced.

That's the biggest issue I see right now. Do we want black and white
specificity? For example, using terms like "must" and "may not" etc. Or
do we want the document to merely hold best practices while not
proscribing exact details? I think even with exact details we can loosen
them if needed, but that has its own can of worms.

Dmitry, what are your thoughts on this?

Thanks,

-- Chase
