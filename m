Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1LJENj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 23:13:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50785 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LJENi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 23:13:38 -0500
MIME-Version: 1.0
X-Originating-IP: [12.185.155.194]
In-Reply-To: <BAY151-W537E90462ED274C21FDA4CA1BE0@phx.gbl>
References: <BAY151-W65C39B54A590BCA4E3AEBDA1B80@phx.gbl>
	<CAKMK7uEm8=bGWxDSbLtOEM3CBmbMSH+gWrUy0Od327ozvjOd5g@mail.gmail.com>
	<BAY151-W537E90462ED274C21FDA4CA1BE0@phx.gbl>
Date: Sat, 10 Dec 2011 05:13:37 +0100
Message-ID: <CAKMK7uH-_VzaeTsNJYL_wMfUHqMkvG-BSCxicfQ--RQ-_O5jsg@mail.gmail.com>
Subject: Re: kernel BUG at drivers/gpu/drm/i915/i915_gem
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Rocko Requin <rockorequin@hotmail.com>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 03:09, Rocko Requin <rockorequin@hotmail.com> wrote:
>> Please report bugs always on the public
>> mailing list so that all interest people can join in
>
> Apologies, I used to log them to the kernel bug tracker, which never came
> back up after kernel.org was rebuilt, and I didn't want to bother the public
> list.

You've trimmed the cc: list and removed intel-gfx and linux-kernel.
Don't do that, people won't see your reply otherwise. Re-added to the
cc: list.

>> Unfortunately you've cut out the backtrace from the
>> kernel oops, so I can't tell anything more.
>
> It wasn't me! The kernel locked up before it could complete writing the
> backtrace to the log, so it simply isn't there (and unfortunately the PC
> didn't switch to a tty to display it). There is the beginning of a backtrace
> from the same bug the day before, but it doesn't get much past the invalid
> opcode line

If you can wire up netconsole you should be able to gather the full
backtrace and that would be really useful. Otherwise can you please
confirm by reverting that commit from your current tree that it is
indeed the culprit? Otherwise please bisect the issue.
-Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
