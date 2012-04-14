Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2DNQDI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 12:03:08 -0400
Received: from 1wt.eu ([62.212.114.60]:65161 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab2DNQDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 12:03:07 -0400
Date: Sat, 14 Apr 2012 18:02:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
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
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414160242.GG19802@1wt.eu>
References: <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413154216.476a02ac@stein> <CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com> <20120413230525.GA13995@burratino> <CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com> <20120414054401.GC19802@1wt.eu> <CAMP44s3uTTWSJCohLGf64vV6h6PgSPJ++UrmeRkRWebJWjvJ_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s3uTTWSJCohLGf64vV6h6PgSPJ++UrmeRkRWebJWjvJ_A@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 06:43:06PM +0300, Felipe Contreras wrote:
> I understand you use 'stable' as guarantee, and I know it works, but
> do you *need* this guarantee?
> 
> And before you go on why you need this guarantee to avoid fixes to be
> lost, this is an *entirely different thing*; we are not talking about
> fixes in 'stable' that don't exist in mainline--for which there is
> evidence that those caused problems in the past, we are talking about
> reverting patches from 'stable' that are not part of the upstream
> release from where the 'stable' branch was forked--*nobody* has showed
> any evidence that this has happened before and caused issues.

Why make a special case for the version from which stable was derived ?
That doesn't make sense at all to me since by definition, *all* patches
that are in stable were not in this version !

Take it simpler if you want : *all* patches in stable need an upstream
commit ID, whether they're backports or reverts. You don't revert a
patch from stable, you backport a revert from upstream.

Willy

