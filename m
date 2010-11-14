Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0KNXYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 18:24:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52567 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab0KNXYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 18:24:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sqxlXQahARuKxb4+sG4b8Pzf7PLDAlkYTvIvuiB3AXXORsWYkTPMjTpYgTh+ZwTKCb
         mSry/qks2IyRKIATLwxlEMzct9InuCq2gjoPZUY+GA4J6dLNQ1ma2WtoNfEgQz1Pt7Bm
         uurV2aLZa4X78t+MZOux2bDmplHptW3bhfh1o=
MIME-Version: 1.0
In-Reply-To: <4CE05A9E.9090204@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
	<4CD6B7FA.3050005@redhat.com>
	<AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
	<AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
	<20101107194547.GA12521@basil.fritz.box>
	<4CD71C8B.1050604@redhat.com>
	<20101107230508.GB17592@basil.fritz.box>
	<20101108145809.GD29714@redhat.com>
	<1289238930-sup-9765@think>
	<20101114205925.GA20451@redhat.com>
	<AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
	<4CE05A9E.9090204@redhat.com>
Date: Mon, 15 Nov 2010 00:24:08 +0100
Message-ID: <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
Subject: Re: dm-crypt barrier support is effective
From: Matt <jackdachef@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 10:54 PM, Milan Broz <mbroz@redhat.com> wrote:
> On 11/14/2010 10:49 PM, Matt wrote:
>> only with the dm-crypt scaling patch I could observe the data-corruption
>
> even with v5 I sent on Friday?
>
> Are you sure that it is not related to some fs problem in 2.6.37-rc1?
>
> If it works on 2.6.36 without problems, it is probably problems somewhere
> else (flush/fua conversion was trivial here - DM is still doing full flush
> and there are no other changes in code IMHO.)
>
> Milan
>

Hi Milan,

I'm aware of your new v5 patch (which should include several
improvements (or potential fixes in my case) over the v3 patch)

as I already wrote my schedule unfortunately currently doesn't allow
me to test it

* in the case of no corruption it would be nice to have 2.6.37-rc* running :)

* in the case of data corruption that would mean restoring my system -
since it's my production box and right now I don't have a fallback at
reach
at earliest I could give it a shot at the beginning of December. Then
I could also test reiserfs and ext4 as a system partition to rule out
that it's
a ext4-specific thing (currently I'm running reiserfs on my system-partition).

Thanks !

Matt
