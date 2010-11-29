Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0K2I7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:59:17 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:32681
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab0K2I7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:59:15 -0500
X-IronPort-AV: E=Sophos;i="4.59,275,1288566000"; 
   d="scan'208";a="80371778"
Date: Mon, 29 Nov 2010 09:59:13 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Microcai <microcai@fedoraproject.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101129085913.GN5142@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Microcai <microcai@fedoraproject.org>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-console@vger.kernel.org
References: <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <1290954545.13526.27.camel@cai.gentoo> <20101128191152.GV10602@const.famille.thibault.fr> <1290993006.877.0.camel@cai.gentoo> <20101129081639.GA5142@const.bordeaux.inria.fr> <AANLkTinmdRjEkmywaMevN5_A=2N8_pBsOAJj8PoAaznz@mail.gmail.com> <20101129082711.GB5142@const.bordeaux.inria.fr> <1291020805.9785.0.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1291020805.9785.0.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai, le Mon 29 Nov 2010 16:53:25 +0800, a écrit :
> 在 2010-11-29一的 09:27 +0100，Samuel Thibault写道：
> > microcai, le Mon 29 Nov 2010 16:20:11 +0800, a écrit :
> > > > But isn't that basically what you are describing?
> > > >
> > > > (i.e. what's the use of using a pts and /dev/fb, if not for a userlevel
> > > > terminal to actually do the work?)
> > > >
> > > 
> > > ok, try run zhcon on pts.  can you do that ?
> > 
> > zhcon _provides_ a pts, that's what I mean.
> 
> So you agree zhcon can't run on pts.

Sure. It doesn't make sense. But what zhcon does should be done in
fbterm.

> Then there's dozens of zhcon.

What do you mean by this?

Samuel
