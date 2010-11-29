Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0K2BI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:08:56 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46171 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0K2BIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:08:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=FKeVEYwJseXfhuEcQ2r+1WgWmdcypo05kfMsG4orKWhRSc1talmo3YRG0j/rjGzrh7
         DeE2xF18+da9jSae+dD1MFrzPvU2zCGoxbWlt+ovDQdIfnjU29AHFfgvyc2jgWJ9l/Zp
         NO8Y+tXKiepHpFMZIsxgXP4mG7PGhj87vcufg=
Subject: Re: VT console need rewrite
From: Microcai <microcai@fedoraproject.org>
Reply-To: microcai@fedoraproject.org
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
In-Reply-To: <20101128191152.GV10602@const.famille.thibault.fr>
References: <1290941875.13526.15.camel@cai.gentoo>
	 <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
	 <1290951770.13526.18.camel@cai.gentoo>
	 <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
	 <1290954545.13526.27.camel@cai.gentoo>
	 <20101128191152.GV10602@const.famille.thibault.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: fedoraproject.org
Date: Mon, 29 Nov 2010 09:10:06 +0800
Message-ID: <1290993006.877.0.camel@cai.gentoo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2010-11-28日的 20:11 +0100，Samuel Thibault写道：
> Microcai, le Sun 28 Nov 2010 22:29:05 +0800, a écrit :
> > So, here is the design according to your description  .. 
> > 
> > JUST export /dev/fb and /dev/pts and /dev/console
> > The kernel use /dev/console, but invisible. 
> > The rest of the world uses /dev/pts
> > 
> > Make init using /dev/fb to display boot message, and agetty runs
> > on /dev/pts
> 
> Errr, but that already exists, that's fbterm...
> 
> Samuel

Every time someone try to implement something , some other guy will jump
out and say, that already exist, in user-space ..... blablablabla

