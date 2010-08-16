Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab0HPBcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 21:32:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35675 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0HPBcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 21:32:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u6ddvamD4vS+nqldILWbGDhW4lZkPpB/HyWNxyfEBcHWoVM5aZ8evRpE/G0Tv37kgB
         AncDL+M1fxSEprzeEo15uJKEJsHeA961DpIoKypB97sh9A3BijhQGJXp838R1jigEZHM
         tYddYfKJ52/7T8EZ2E0zRfNDqu31LjRvwS7Hk=
MIME-Version: 1.0
In-Reply-To: <AANLkTik0qJ_Nd7YLii0dm6z-sbwqHLxURPaWVRKDtUSA@mail.gmail.com>
References: <AANLkTinfgXOzbqgrRY4oCGXFtKtEyJO_rvQeeEEeEZz7@mail.gmail.com>
	<AANLkTimoD+-KzXVJhaKNZRvb=MkRgRUEQWnGNEwjvoRL@mail.gmail.com>
	<AANLkTik0qJ_Nd7YLii0dm6z-sbwqHLxURPaWVRKDtUSA@mail.gmail.com>
Date: Mon, 16 Aug 2010 09:32:03 +0800
Message-ID: <AANLkTin+=BXWFo=NKbbnydO4U=YA2Vz7BZDXAvWvUyP6@mail.gmail.com>
Subject: Re: [PATCH] mm: code improvement of check_stack_guard_page
From: jovi zhang <bookjovi@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 1:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Aug 14, 2010 at 10:15 PM, jovi zhang <bookjovi@gmail.com> wrote:
>>
>> little code improvement of check_stack_guard_page function.
>> this commit is on top of commit "mm: keep a guard page below a
>> grow-down stack segment" of linus.
>
> I don't think your patch is in any way wrong, but I just checked, and
> it makes absolutely zero difference to the code generation at least
> for my version of gcc. The resulting assembly is identical except for
> the line numbers that changed (BUG_ON() line/file information and
> debug information).
>
> So I think I prefer the shallower indentation.
>
>                       Linus
>

That's fine. I havn't consider gcc optimization.
