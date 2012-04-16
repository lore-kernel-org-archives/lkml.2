Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2DPPoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:44:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33408 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979Ab2DPPoL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:44:11 -0400
MIME-Version: 1.0
In-Reply-To: <1334590461.2250.0.camel@localhost>
References: <20120416154607.302f7ae245472e1e917dacef@canb.auug.org.au>
	<CABqD9hauxzd4vVbxyC5M1p9e6mLt1cjYP7wbhzTKPi3iMpc0kg@mail.gmail.com>
	<1334590461.2250.0.camel@localhost>
Date: Mon, 16 Apr 2012 10:44:09 -0500
Message-ID: <CABqD9haMbVKn=cKuE75hSQ1YG9FgnzDhAaGUhTvk0kvJS8MGGg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (security
 tree related)
From: Will Drewry <wad@chromium.org>
To: Eric Paris <eparis@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, James Morris <jmorris@namei.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:34 AM, Eric Paris <eparis@redhat.com> wrote:
> On Mon, 2012-04-16 at 10:32 -0500, Will Drewry wrote:
>
>> Thanks for this, and the other two fixes!  I'll pull together a patch
>> fixing up the other call sites.  My past revisions had avoided this by
>> using a new symbol, and I totally forgot to touch these up in the last
>> round.
>>
>> What's the best way to submit the clean up -- against the security-next tree?
>>
>> Thanks and sorry for the noise!
>
> Just send fixes to James and they will get picked up by Stephen the day
> after he commits them to security-next.

Cool - thanks!
