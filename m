Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab0HLAqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:46:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62363 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692Ab0HLAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mkahsEuZLi/Ljq4UkKbIXKnIp8cgTZ1biD1WPGFUrpoxQ7X9FMrUY3u8B9CjhilJ73
         DeU4TXapKn4mhS+awsCRjghMM3dBYL2OWJv8eexvjoKWMZXKYkXLq7FkZ48nnxr7yciy
         u4LKYNZduyLSy8Gie+m+GFvfb0Oi6FYIb8Ro0=
MIME-Version: 1.0
In-Reply-To: <AANLkTimwdJgAUHNgUDwagDhBd2MtEoSbt7rFa2dPkm2c@mail.gmail.com>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<AANLkTinNc1SWmz8pE_4k6vThxQCJfCR_UqV6OM=OsJOf@mail.gmail.com>
	<20100811193106.GB24435@thunk.org>
	<AANLkTinBrp1iHWAi=vk_eaEHMs+Xcub6rg8PgT_LK2c9@mail.gmail.com>
	<AANLkTinOb5PsrLbMzbYVqqx=6n-yPNRCYgOf4fM5KdXJ@mail.gmail.com>
	<AANLkTimAKwDPYZeCj_UEyXf-6DxLg8=Zi-=tFKzzgvQi@mail.gmail.com>
	<AANLkTimwdJgAUHNgUDwagDhBd2MtEoSbt7rFa2dPkm2c@mail.gmail.com>
Date: Thu, 12 Aug 2010 03:46:34 +0300
Message-ID: <AANLkTinWmZZHd6uRRY-RRj_qu5P-3BjY8LRWrpRwFncH@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Brian Swetland <swetland@google.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 1:12 AM, Brian Swetland <swetland@google.com> wrote:
> On Wed, Aug 11, 2010 at 3:03 PM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> This is what I'm talking about when I say multi-tasking, Android
>> certainly doesn't have anything remotely like that:
>> http://www.youtube.com/watch?v=7emvUBpEkbU
>
> Home + pick app -> switch to the app in whatever state it was in.

If the app stops running, that's *fake* multi-tasking, and doesn't
match my experience; I can't remember the details, but I tested it on
a Nexus One, and the item I was looking at was gone, I had to scroll
again.

Also, I cannot go to last.fm on the browser, play some music, and do
other stuff at the same time, can I?

Anyway, what you do in Android is your problem. The point is that in
Linux we need good PM *with* multi-tasking (not really an argument
against opportunistic suspend, I think, but a clarification from Ted's
comment)

-- 
Felipe Contreras
