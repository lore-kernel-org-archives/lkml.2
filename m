Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0K2IwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:52:18 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35607 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0K2IwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:52:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=IL9sX4cfbqoRtLOKYx4ODpHKBEhWJB64iCBm510UyH7OP0/R2a45jrCOOCBpbafyoY
         CMJzo9EHKFepy8jGIyDeTTz8d4LQpGCg6g9DO3yPVAimeWUkgBxsP0CL/oH3a4G1/gAo
         dQaz2ZGrnxdAFSMfHo7C6UsBd4b9wmsa7jg6s=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101129082711.GB5142@const.bordeaux.inria.fr>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <1290954545.13526.27.camel@cai.gentoo>
	 <20101128191152.GV10602@const.famille.thibault.fr>
	 <1290993006.877.0.camel@cai.gentoo>
	 <20101129081639.GA5142@const.bordeaux.inria.fr>
	 <AANLkTinmdRjEkmywaMevN5_A=2N8_pBsOAJj8PoAaznz@mail.gmail.com>
	 <20101129082711.GB5142@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 16:53:25 +0800
Message-ID: <1291020805.9785.0.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-29一的 09:27 +0100，Samuel Thibault写道：
> microcai, le Mon 29 Nov 2010 16:20:11 +0800, a écrit :
> > > But isn't that basically what you are describing?
> > >
> > > (i.e. what's the use of using a pts and /dev/fb, if not for a userlevel
> > > terminal to actually do the work?)
> > >
> > 
> > ok, try run zhcon on pts.  can you do that ?
> 
> zhcon _provides_ a pts, that's what I mean.

So you agree zhcon can't run on pts.
Then there's dozens of zhcon.


