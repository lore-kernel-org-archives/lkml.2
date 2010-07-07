Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0GGKSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 06:18:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34662 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0GGKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 06:18:50 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.13.124]
In-Reply-To: <AANLkTikAZCAj4mljYbJcppuIL2quYz8AK0AkTFCZO3bG@mail.gmail.com>
References: <1277298125-17991-1-git-send-email-ohad@wizery.com> 
	<1277298840-18516-1-git-send-email-ohad@wizery.com> <20100623224150.GA6680@kroah.com> 
	<AANLkTik0rm12w4jplD1vSTZnPbwguDU6xtOdAfs9C-3r@mail.gmail.com> 
	<4C33513C.4090704@ti.com> <AANLkTikAZCAj4mljYbJcppuIL2quYz8AK0AkTFCZO3bG@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 7 Jul 2010 13:18:28 +0300
Message-ID: <AANLkTil0dSafGxmwoNnA6kJQE3sHRg-pBdNDB7vfhcpv@mail.gmail.com>
Subject: Re: [PATCH 11/11] staging: ti dspbridge: enable driver building
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>, Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>, "Menon, Nishanth" <nm@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 12:31 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Tue, Jul 6, 2010 at 6:52 PM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
>> at that point *you* wanted your patches not to be
>> included if the last one wasn't merged in.
>
> Not without the copyright update patch.
...
> So. Would you care to give a reason why my contributions don't deserve
> a copyright?


Disclaimer: I am not a lawyer, and I speak only for myself in this
post, and doesn't represent TI in anyway.


AFAICT, you get copyright for every kernel change you submit and is
accepted. Even if you just contribute whitespace cleanups, you get the
copyright to those cleanups (not to suggest this was the sole
contribution here).

The copyright assignment is per the actual git commit itself,
obviously, and it doesn't apply for the rest of the code in those
files you edited.

There are some exceptions, but they are not applicable here:
- Usually when you get paid for the work, the employer keeps the
copyright of the patch, not the author.
- There are some projects where you have to relinquish the copyright
in order for the patch to be accepted. This is how FSF (Free Software
Foundation) projects work (e.g. gcc), but not the Linux kernel (which
is not a FSF project).

As I mentioned, I don't think these exceptions apply in this case, and
AFAICT, Felipe - you inherently get the copyright for the changes that
your accepted patches introduce.

So it all boils down to the semantic question whether to edit the
header file, adding new copyright lines, or not.

Felipe, I think your contributions are important and helpful, and I
would personally be happy if you continue to do them. I personally
don't think that adding an explicit copyright line to the header
should be important, because you get your copyright anyway. The exact
change, to which you get copyright on, is kept in the git history, and
will not likely to go away. I think this is pretty satisfying, and as
a result, you don't see people(/companies) changing copyright headers
when they submit kernel patches that edit existing files.

The only thing I am not sure about, and that may be a concern to TI,
is whether adding a copyright line in the header might actually give
copyright ownership for the complete file. If this is true, I can
understand why TI might not be so keen in adding copyright owners to
the file header, without explicitly specifying what is the copyright
about (not to suggest any opinion of TI on the matter, I speak only
for myself).


Again: I am not a lawyer, and I speak only for myself in this post,
and doesn't represent TI in anyway.


Thanks,
Ohad.


>
> --
> Felipe Contreras
>
