Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0LHTKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:10:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:54652 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab0LHTJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:09:59 -0500
Message-ID: <4CFFD801.8060704@canonical.com>
Date: Wed, 08 Dec 2010 11:09:53 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Add an envelope tool type
References: <1291721340-22652-1-git-send-email-rydberg@euromail.se> <4CFFC3C2.1080905@canonical.com> <4CFFCD10.5030202@euromail.se> <4CFFD0BF.2020601@canonical.com> <4CFFD3FE.1090103@euromail.se>
In-Reply-To: <4CFFD3FE.1090103@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 10:52 AM, Henrik Rydberg wrote:
>> As you noted, what we are really interested here is a bounding
>> rectangle. I think Ping has said that Wacom could provide something that
>> is similar to a real convex hull, and mixing the two concepts together
>> could cause another ambiguity like BTN_TOOL_DOUBLETAP :).
> 
> 
> True, we should work towards avoiding such ambiguities.
> 
>> I suggest merely renaming this to MT_TOOL_RECT to avoid confusion.

This is really the main point I wanted to make, even though it was
hidden among other things :). Do you have thoughts here?

>> 2. We could provide for multiple simultaneous rects by using the value
>> of the MT_TOOL_RECT property. The first rect would have value 0, the
>> second would have value 1, etc. I don't know if this will ever be used
>> since most devices will have real MT soon enough, but it wouldn't hurt
>> to define this.
> 
> I do think this is an unnecessary complication.

It's not really any complication. I think we should define what the
valid values are for MT_TOOL_{RECT,ENVELOPE} even if only one envelope
is supported. Thus, I don't see why we shouldn't allow for multiple
values for multiple rects.

Hardware manufacturers always seem to surprise us with what they come up
with too :).

-- Chase
