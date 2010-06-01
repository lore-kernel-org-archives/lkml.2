Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab0FAFAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:00:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:30020 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab0FAFAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=d8hLFXBsSAm9fQQNanOG4s2iSToXjy807ZcGbg1wnNuPqUZ3F+amAdknLmkP9+jViK
         YSitOA2fJEtieY3Sh551mU823KDf8Sd/DJomdLiFGf+mJ4N7Rdeeceg6ww6H+FSB5e3R
         +tzNKQMIDgE4jbbkSl48gMmrRYXl3e/RTBgqk=
MIME-Version: 1.0
In-Reply-To: <20100601041028.GB4426@thunk.org>
References: <1275347969.29006.5.camel@lithium.local.net>
	<20100601041028.GB4426@thunk.org>
Date: Tue, 1 Jun 2010 08:00:39 +0300
X-Google-Sender-Auth: WBZ4RlIYkyPNbE36GoXqdYrfkpg
Message-ID: <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35 release 
	candidates
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 7:10 AM,  <tytso@mit.edu> wrote:
> On Tue, Jun 01, 2010 at 12:19:29AM +0100, Alex Buell wrote:
>> http://www.phoronix.com/vr.php?view=14976
>>
>> Question: Why?
>
> One of the theories that has been advanced is that it's simply this
> problem:
>
>        http://lkml.org/lkml/2010/5/22/154
>
> If so, it points out how idiotic Phoronix is about not being able to
> notice udev pegging the CPU at 100% being someone bad for its
> benchmark runs.  :-)
>
> OTOH, this bug has been known for over a week, and it is sort sad that
> we haven't reverted this patch.  It looks like the conversation has
> died, but without a fix?

It's fixed by 1eb2cbb6d5efe129 so the problem doesn't exist for 2.6.35-r1.
