Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2DNPnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:43:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47515 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146Ab2DNPnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120414054401.GC19802@1wt.eu>
References: <20120412144626.GA14868@kroah.com>
	<CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
	<CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
	<CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
	<20120413105746.10ffb120@stein>
	<CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
	<20120413154216.476a02ac@stein>
	<CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com>
	<20120413230525.GA13995@burratino>
	<CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
	<20120414054401.GC19802@1wt.eu>
Date: Sat, 14 Apr 2012 18:43:06 +0300
Message-ID: <CAMP44s3uTTWSJCohLGf64vV6h6PgSPJ++UrmeRkRWebJWjvJ_A@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 8:44 AM, Willy Tarreau <w@1wt.eu> wrote:

> Nobody has said it's perfect. Jonathan said it's "close" to perfect. I
> personally think it's the best tradeoff we could find between a perfectly
> stable branch and a perfect mainline. We manage to converge towards the
> best quality in both branches by accepting a small delay in -stable.

You are saying the same thing; it cannot be improved.

> The problem is that *you* don't accept to wait as soon as you know there's
> a bug,

I'm going to stop right here. You are making an eloquent argument for
something nobody is saying.

This is pure straw man argumentation, see the reply from Stefan
Richter, who seems to be the only person who is actually following the
argument I'm making.

> Reverting patches that were not appropriate for -stable happens from
> time to time, but only when the issue is specific to -stable (eg: build
> issues). Here what you don't seem to understand is that the bug was
> not specific to -stable but was present everywhere. So we had a bug
> in mainline that we put in -stable, and we want mainline to be fixed
> and we use -stable as a guarantee that mainline will be fixed. And it
> works and has never failed yet. That's not hard to understand I think.

I understand you use 'stable' as guarantee, and I know it works, but
do you *need* this guarantee?

And before you go on why you need this guarantee to avoid fixes to be
lost, this is an *entirely different thing*; we are not talking about
fixes in 'stable' that don't exist in mainline--for which there is
evidence that those caused problems in the past, we are talking about
reverting patches from 'stable' that are not part of the upstream
release from where the 'stable' branch was forked--*nobody* has showed
any evidence that this has happened before and caused issues.

Only Stefan Richter is trying to tackle this argument.

Cheers.

-- 
Felipe Contreras
