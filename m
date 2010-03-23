Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0CWBoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:44:55 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:35077 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab0CWBoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mAJrzkaK4ggpVxYW83+rbKnM3qLIP5vPw1TfMZoYhc2C6XsY5FbWKIVuBOtNziyW4e
         dy6rkJND+VQGhYNBI6e4DvAoAJieCYzDoeGnaPX4zfL7vsIMpHATwQWJ8O37B4iEtoA0
         z+ScpHFAsljewjMkIX96dvj90yFv/RNg3asIk=
MIME-Version: 1.0
In-Reply-To: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com>
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com>
Date: Tue, 23 Mar 2010 11:44:53 +1000
Message-ID: <21d7e9971003221844k6ce67f40k69981ff92f29f20b@mail.gmail.com>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
From: Dave Airlie <airlied@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 11:12 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hello.
>
> After update to 2.6.34-rc1, I was experimented by strange oopses during
> boot, what looked like memory corruption. Bisection shows that first bad
> commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
> support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
> system. Not sure what info is need to track down this issue, so please
> let me know.
>

I had a similar issue today, wasted a morning try to get either -rc1
or -rc2 to boot on my 32-bit desktop here,
until I worked out that the default for this option is to be on.

I suggest CONFIG_NO_BOOTMEM be default n for now.

Not sure why it was merged as default y.

Dave.
