Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab0LHTXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:23:41 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:37751 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756330Ab0LHTXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:23:40 -0500
Message-ID: <4CFFDB35.2020506@euromail.se>
Date: Wed, 08 Dec 2010 20:23:33 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com> <4CFFCD10.5030202@euromail.se> <4CFFD0BF.2020601@canonical.com> <4CFFD3FE.1090103@euromail.se> <4CFFD801.8060704@canonical.com>
In-Reply-To: <4CFFD801.8060704@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PQPbz-0001yZ-6u.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PQPbz-0001yZ-6u 54d4e6c1c5f9ef3e96239d14702e9bb8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I suggest merely renaming this to MT_TOOL_RECT to avoid confusion.

> 
> This is really the main point I wanted to make, even though it was
> hidden among other things :). Do you have thoughts here?


I think envelope works fine - it is easier to associate with a single point that
the notion of a rectangle.

>>> 2. We could provide for multiple simultaneous rects by using the value
>>> of the MT_TOOL_RECT property. The first rect would have value 0, the
>>> second would have value 1, etc. I don't know if this will ever be used
>>> since most devices will have real MT soon enough, but it wouldn't hurt
>>> to define this.
>>
>> I do think this is an unnecessary complication.
> 
> It's not really any complication. I think we should define what the
> valid values are for MT_TOOL_{RECT,ENVELOPE} even if only one envelope
> is supported. Thus, I don't see why we shouldn't allow for multiple
> values for multiple rects.

> 
> Hardware manufacturers always seem to surprise us with what they come up
> with too :).


Yes, which is exciting per se. However, hardware seems to be moving towards more
individual (and tracked) contacts, and more granularity per contact. The idea of
supporting complex, non-connected boundaries (implication of your proposal),
which by construction contains less information that the individual contacts,
seems to be going against that trend. Since there are no current need for it,
and the indications point in a different direction, I suggest we put that in the
bag of possible "I told you so", and leave it open for now. ;-)

Cheers,
Henrik
