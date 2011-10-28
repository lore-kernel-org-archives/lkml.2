Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1J1RBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 13:01:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52040 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1J1RBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 13:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <20111028163053.GC1319@redhat.com>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	<75efb251-7a5e-4aca-91e2-f85627090363@default>
	<20111027215243.GA31644@infradead.org>
	<1319785956.3235.7.camel@lappy>
	<CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
	<552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
	<CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com>
	<20111028163053.GC1319@redhat.com>
Date: Fri, 28 Oct 2011 20:01:43 +0300
X-Google-Sender-Auth: wFE-35YDUAwT5s3c_68uEk-A_cM
Message-ID: <CAOJsxLEGnpuwmrhO0QJFuOoh5itYFyphtyg+VGH0qdrGH=8zYw@mail.gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
From: Pekka Enberg <penberg@kernel.org>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 7:30 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> People did look at it.
>
> In my case, the handwavy benefits did not convince me.  The handwavy
> 'this is useful' from just more people of the same company does not
> help, either.
>
> I want to see a usecase that tangibly gains from this, not just more
> marketing material.  Then we can talk about boring infrastructure and
> adding hooks to the VM.
>
> Convincing the development community of the problem you are trying to
> solve is the undocumented part of the process you fail to follow.

Indeed. I don't also understand why this is useful nor am I convinced
enough to actually try to figure out how to do the swapfile hooks
cleanly.

                          Pekka
