Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932957Ab1J1O03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:26:29 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61351 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab1J1O00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.com>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<75efb251-7a5e-4aca-91e2-f85627090363@default>
	<20111027215243.GA31644@infradead.org>
	<1319785956.3235.7.camel@lappy>
	<CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.com>
Date: Fri, 28 Oct 2011 17:26:24 +0300
X-Google-Sender-Auth: -wTyeHVkjZ6CRoPVrRlDdGrfWAo
Message-ID: <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
From: Pekka Enberg <penberg@kernel.org>
To: Cyclonus J <cyclonusj@gmail.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:30 AM, Cyclonus J <cyclonusj@gmail.com> wrote:
>> I felt it would be difficult to try and merge any tmem KVM patches until
>> both frontswap and cleancache are in the kernel, thats why the
>> development is currently paused at the POC level.
>
> Same here. I am working a KVM support for Transcedent Memory as well.
> It would be nice to see this in the mainline.

We don't really merge code for future projects - especially when it
touches the core kernel.

As for the frontswap patches, there's pretty no ACKs from MM people
apart from one Reviewed-by from Andrew. I really don't see why the
pull request is sent directly to Linus...

                        Pekka
