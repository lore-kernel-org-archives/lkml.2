Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1FHIAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:00:43 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61693 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab1FHIAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gbq6NRipoj+6ZjQs/ZBW5L4b+wk/eHi9XjM4F9pmg2RDeMnGNNFaB8A9euEdHYTK8Z
         xCqSqhbxv7meaqjqQR57dv38DakSGQs1KBb7BPq1xHGSnuDJZr36m0vbswzZcTeBMAAl
         g+XtPQNXsUcOkGa5kEbSXOf7FKyrAIPXb05yo=
MIME-Version: 1.0
In-Reply-To: <C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
References: <4DEE1D96.6020208@profihost.ag>
	<6D8DA3D2-D90B-4D82-BDC9-C3F0264A68BF@mit.edu>
	<4DEE2C70.8060301@profihost.ag>
	<alpine.DEB.2.02.1106071239530.28905@asgard.lang.hm>
	<4DEE9EDA.90001@profihost.ag>
	<C4F797E7-3B2F-4BAD-BF69-2182DEA775A5@mit.edu>
Date: Wed, 8 Jun 2011 10:00:39 +0200
X-Google-Sender-Auth: VjOB798KOB13M_XCahJ3aVjYCmI
Message-ID: <BANLkTim3GuppJ4=VHa0BgNV1d4nQjWUcbg@mail.gmail.com>
Subject: Re: XFS problem in 2.6.32
From: John Kacur <jkacur@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>, david@lang.hm,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 5:28 AM, Theodore Tso <tytso@mit.edu> wrote:
>
> On Jun 7, 2011, at 5:57 PM, Stefan Priebe - Profihost AG wrote:
>
>>> whoever the maintainer of the -stable/-longterm tree is (be it an
>>> individual or a team employeed by some comapny) then looks at the patch
>>> and considers backporting it (if it's too hard, or to intrusive, they
>>> may decide not to).
>> So i have to contact Greg Kohan from SUSE directly?
>
> Only if you can identity a specific patch you want backported to 2.6.32.
>
> It's not the responsibility of the long-term stable tree maintainer to go looking through potentially tens of thousands of commits to find the one that should be backported.  And if the code has changed too much since .2.6.32, and requires detailed reworking before the patch can get integrated into 2.6.32, then a subsystem developer will have to do that work.
>
>>
>>> the idea of the lonterm kernels is that organizations need to maintain a
>>> kernel for a long time due to commitments that they have made (Debian
>>> doesn't want to change the kernel it ships in a stable version, RedHat
>>> doesn't want to change the kernel version in a RHEL release, etc), and
>>> so they publicly announce this so that anyone else wanting to use the
>>> same kernel version can share in the work (and therefor everyone can
>>> benifit from each other's work)
>> That was what i thoght. So a bug like this should get fixed right? Otherwise this makes no sense. Sadly Redhat has ported the fix back in his RHEL 6 2.6.32 kernel but they haven't send the patch to stable / vanilla team.
>
> Not all distributions will participate in the maintenance stable tree.  Red Hat for example is probably worried about people  (specifically, Oracle) taking their kernel expertise "for free" and bidding it against them.  So it doesn't surprise me that they aren't submitting patches to the stable tree.  After all, they would like you to purchase a support contract if you want to get high quality, supported kernel.   Why should they give that work away for free?  After all, their salaried developers have to get paid somehow.  Others will contribute work in the hopes that other people will also contribute fixes back, but of course nothing forces Red Hat to do this.
>
> The thing that you have to understand that this is all a volunteer effort, and a few of your messages sound like you are expecting people to do the work for you.   It doesn't work that way.  If you ask nicely, maybe one of the XFS developers will help you.  But please don't expect free support.  That will just annoy people.
>

Ok, I don't speak for my company, and your point about not expecting
people to do this work for you is valid, however I don't see why you
need to take potshots at Red Hat, - they are quite active in the
stable effort.

wget http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.38.8
grep Author ChangeLog-2.6.38.8 | grep -i redhat | wc -l
9

grep Author ChangeLog-2.6.38.8 | grep -i suse | wc -l
10

grep Author ChangeLog-2.6.38.8 | grep -i canonical | wc -l
5

I'm not even claiming that these are typical stats, but as just a
quick check on your statement, the contributions for one stable
release are in the same ballpark as everyone else.
Don't know if lwn has stable stats.

Thanks

John
