Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab1BMXed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 18:34:33 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49873 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab1BMXe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 18:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Em5v3za/gaNmWpm7HAW2F4fd9G6SLg5p++CYEN9mdfWCiqf75gq5Qak0dwAIUFzqLE
         32xMM3E8UqKdJ9KBefsPCbURyGYArTRkbxTz9BQLANduer0Vp5UFyGfp49sQtE2Oa9rM
         WaKSRCshMYfNEYYroCSC3Zv+OBSR5sPCywqzo=
MIME-Version: 1.0
In-Reply-To: <20110213233121.GA10495@sequoia.sous-sol.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
	<AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
	<20110213233121.GA10495@sequoia.sous-sol.org>
Date: Mon, 14 Feb 2011 09:34:28 +1000
Message-ID: <AANLkTimXQy4dwjZpAFHs5zgCfVYR5QU08ydx9xUzSd+n@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
From: Dave Airlie <airlied@gmail.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 9:31 AM, Chris Wright <chrisw@sous-sol.org> wrote:
> * Dave Airlie (airlied@gmail.com) wrote:
>> On Sun, Feb 13, 2011 at 4:22 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > With kernel built from current linus's tree, I can not start xorg,
>> > it failed with:
>>
>> Me too!,
>>
>> Thanks for bisceting this, I just tried -rc4 on my Fedora 13 laptop
>> and wasn't looking forward to bisecting it.
>>
>> If this isn't hitting later distros its probably an updated
>> libpciaccess that fixed something.
>>
>> libpciaccess-0.10.9-2.20091209.fc13.i686 is what is on this box.
>>
>> Probably should revert first, then work out what is crapping out libpciaccess.
>
> Are you running with SELinux enabled, if so can you paste the AVC error?
> It's working for me here.

Yes most likely, I'm not at the machine now but I'll see if I can the
AVC off it later.

On Fedora 13?

F14/rawhide seem fine.

Dave.
