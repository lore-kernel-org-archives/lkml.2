Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab0K2IQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:16:44 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:33887 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0K2IQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:16:42 -0500
X-IronPort-AV: E=Sophos;i="4.59,275,1288566000"; 
   d="scan'208";a="81139750"
Date: Mon, 29 Nov 2010 09:16:39 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Microcai <microcai@fedoraproject.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101129081639.GA5142@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Microcai <microcai@fedoraproject.org>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-console@vger.kernel.org
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <1290954545.13526.27.camel@cai.gentoo> <20101128191152.GV10602@const.famille.thibault.fr> <1290993006.877.0.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290993006.877.0.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai, le Mon 29 Nov 2010 09:10:06 +0800, a écrit :
> 在 2010-11-28日的 20:11 +0100，Samuel Thibault写道：
> > Microcai, le Sun 28 Nov 2010 22:29:05 +0800, a écrit :
> > > So, here is the design according to your description  .. 
> > > 
> > > JUST export /dev/fb and /dev/pts and /dev/console
> > > The kernel use /dev/console, but invisible. 
> > > The rest of the world uses /dev/pts
> > > 
> > > Make init using /dev/fb to display boot message, and agetty runs
> > > on /dev/pts
> > 
> > Errr, but that already exists, that's fbterm...
> 
> Every time someone try to implement something , some other guy will jump
> out and say, that already exist, in user-space ..... blablablabla

But isn't that basically what you are describing?

(i.e. what's the use of using a pts and /dev/fb, if not for a userlevel
terminal to actually do the work?)

Samuel
