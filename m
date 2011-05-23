Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab1EWXKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:10:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35288 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab1EWXKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C4cGTXM5iCQEH5cvbxYmSsgY1mC0+hyjkfefIYO3amw5f+piS5kOTR9Avy7q4+YINi
         gKulKxQDWmiMzffGfRy8BljJ/uAOXbYXApqjXxVfcTier8igoID7ShbjGbB8cMnpzwfO
         T5E1YbQC2x4pO0g30n+RTXYe1kP3efV8jChno=
MIME-Version: 1.0
In-Reply-To: <BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
References: <BANLkTi=PLuZhx1=rCfOtg=aOTuC1UbuPYg@mail.gmail.com>
	<20110523192056.GC23629@elte.hu>
	<BANLkTikdgM+kSvaEYuQkgCYJZELnvwfetg@mail.gmail.com>
Date: Mon, 23 May 2011 19:10:21 -0400
Message-ID: <BANLkTi=KJr=g9KQartO+Q3zLd2HqRtoEvg@mail.gmail.com>
Subject: Re: (Short?) merge window reminder
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 4:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, May 23, 2011 at 12:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> I really hope there's also a voice that tells you to wait until .42 before
>> cutting 3.0.0! :-)
>
> So I'm toying with 3.0 (and in that case, it really would be "3.0",
> not "3.0.0" - the stable team would get the third digit rather than
> the fourth one.

Could we set a goal of having 3.0 be the first release with a totally
cleaned up ARM arch? That would give everyone a good target to work
towards.

-- 
Jon Smirl
jonsmirl@gmail.com
