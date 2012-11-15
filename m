Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768936Ab2KOUXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 15:23:52 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54307 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768914Ab2KOUXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 15:23:50 -0500
MIME-Version: 1.0
In-Reply-To: <20121115132550.GA5570@mudshark.cambridge.arm.com>
References: <1352587485-18348-1-git-send-email-keescook@chromium.org>
	<CAGXu5jKYGCkL3GS4Tbep==WUAqP-c_0edAdgy0XQ84rJxZUU2Q@mail.gmail.com>
	<20121115132550.GA5570@mudshark.cambridge.arm.com>
Date: Thu, 15 Nov 2012 12:23:48 -0800
X-Google-Sender-Auth: nd8esNkQ-efi29WNezNccnkL8dc
Message-ID: <CAGXu5jL6og3xq_V=FkemV828Tso5F4wSoLy_24HA_LFw_x20Zw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] arch/arm: support seccomp
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Geremy Condra <gcondra@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 5:25 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Nov 14, 2012 at 07:07:13PM +0000, Kees Cook wrote:
>> Hi, any more thoughts on this series? I'd really like to get it into
>> -next. It's been running happily for a while now in the Chrome OS ARM
>> devices.
>
> I'm not familiar with seccomp in general, but the changes look ok now from
> an ARM point-of-view:
>
>   Reviewed-by: Will Deacon <will.deacon@arm.com>
>
> These should probably go via Russell (who will put them into -next), so
> please send them to the patch system.

Thanks. Is there a sensible way to send an ordered patch series to the
patch system? The Help doc says:
   Please omit [PATCH] and other "useful" prefixes.
(and it wants the "KernelVersion: " in there too)

Is there some way to indicate 1/4, 2/4, etc?

-Kees

-- 
Kees Cook
Chrome OS Security
