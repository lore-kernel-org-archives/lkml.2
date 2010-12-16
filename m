Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0LPOoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:44:25 -0500
Received: from csmtp1.one.com ([195.47.247.21]:50044 "EHLO csmtp1.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869Ab0LPOoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:44:24 -0500
Message-ID: <4D0A23C6.7000308@bitmath.org>
Date: Thu, 16 Dec 2010 15:35:50 +0100
From: Henrik Rydberg <rydberg@bitmath.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Chris Bagwell <chris@cnpbagwell.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Alternative approach to MT_TOOL_ENVELOPE
References: <4D0897F3.7040500@bitmath.org>	<4D08FD74.4060403@canonical.com> <AANLkTik4aS4mA_yrEDiG0QRxHx2pJ+KGGMKEWSDep1CB@mail.gmail.com> <4D092E34.8060002@canonical.com>
In-Reply-To: <4D092E34.8060002@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>

> I do think that MT is complex enough that related documentation should
> be in multi-touch-protocol.txt, though. Anywhere I discussed MT in
> evdev-codes.txt I referred the reader to the other file. Henrik, does
> that sound good to you?


Yep, thanks.

>> I think it will be invaluable to document this stuff for driver
>> writers and apps but I'm not sure yet what level needs to be enforced.
> 
> That's the biggest issue I see right now. Do we want black and white
> specificity? For example, using terms like "must" and "may not" etc. Or
> do we want the document to merely hold best practices while not
> proscribing exact details? I think even with exact details we can loosen
> them if needed, but that has its own can of worms.


It will most likely need to be judged on a case-by-case basis.

Thanks,
Henrik
