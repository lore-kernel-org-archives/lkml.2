Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0DDO4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 10:56:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36387 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab0DDO4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 10:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jKsVcXq1HaOYgxASWGb02XdqelwaoHHW7zCXsx08EmhvI3BvrqmaErzXgyL9x7Q9Ix
         VmtJmfwDfOI9fy/SYYnw/G+z5F25WQLVMtonnFDM+4vw0zMobcODAIjTeofcl402RQiX
         ZWkZ+G1jMx51yDqiah6vo/0QIQn3/Oecl0Stg=
MIME-Version: 1.0
In-Reply-To: <20100404135621.GA16351@lunn.ch>
References: <1270341625-28764-1-git-send-email-luisbg@ubuntu.com>
	 <201004040312.28481.sven.eckelmann@gmx.de>
	 <p2x506b70dc1004031845p81705070o325d93f839c80e9a@mail.gmail.com>
	 <20100404135621.GA16351@lunn.ch>
Date: Sun, 4 Apr 2010 15:56:37 +0100
X-Google-Sender-Auth: dd89db081343ef34
Message-ID: <k2t506b70dc1004040756rea2635f9g358ddbb953ae2bf9@mail.gmail.com>
Subject: Re: [B.A.T.M.A.N.] [PATCH 4/4] Staging: batman-adv: fix whitespace 
	style issues
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>,
       Sven Eckelmann <sven.eckelmann@gmx.de>, devel@driverdev.osuosl.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 4, 2010 at 2:56 PM, Andrew Lunn <andrew@lunn.ch> wrote:
>> Sorry about the conflict, thanks for redoing the changes. Where can I
>> find the current and development branches? I want to avoid doing this
>> mistake again in the future. Specially since I'm planning on doing
>> some janitorial work on Staging for a while if it's OK with you guys.
>> I see it as nice experience and practice while learning and getting
>> ready for more valuable contributions :)
>
> Sven has told you about how batman uses different repositories. You
> can find some more information at:
>
> http://www.open-mesh.org/wiki/UsingBatmanGit
>
> When working on other staging drivers i suggest you work on either the
> linux-next tree, or contact the driver maintainers and ask if they
> have there own development tree. Staging drivers tend to be fast
> moving. They change a lot. What is in the current release kernel,
> which is effectively 3 months old, can be very different to the latest
> development version. I've received many patches to things we have
> fixed months ago and are either waiting in linux-next for the next
> kernel release, or our in or development tree. I'm sure the same
> applies to other drivers in staging.

Andrew,

Oh thanks! After learning about this about the batman development tree
I wondered how to find out where the equivalent branches for other
projects are. Checking the linux-next branch sounds great. I'm still
learning the details of the kernel development process, I knew about
this branch but now I understand it's function and purpose.

I will also contact driver maintainers before sending a patch even if
it is small. I appreciate hugely that Sven redid my changes with the
new branch, but I don't want to create more work for a maintainer in
the future. On the contrary, I want to help :)

>
> Another option for interesting work to get involved in the kernel is
> to ask GregKH if there is a staging driver which is not being actively
> worked on. Some drivers just get dumped there and nobody spends the
> time and effort needed to get them merged. After a while they get
> thrown out of the staging. You could adopt such a driver, get hold of
> the hardware and do the work needed to get it out of staging and into
> the main tree.
>
>    Andrew

That sounds awesome. I will contact him and see if there is any orphan
driver that is of my interest and that I can get my hands on the
hardware. I presume it is a good starting point since it involves
doing the last steps of the process and not starting something from
scratch. A good angle to understand the 'big picture' of driver
development better.

Thanks a million for the suggestions and help. :)

Luis


PD: By the way, I know top posting is a big no-no. is inline posting
ok? in cases like your email where the two paragraphs address diferent
topics I find it more logical to down-post after each one. just
checking before I continue doing so.
