Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab0K2IUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:20:36 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60325 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0K2IUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type;
        b=NzE4/beB7LgJnmeY6BtsESU/gKGy7Dt09Bank7zVgHl1mrt6GBG99gVZsvVvRorDQy
         O57m2F7kDQ6nMvFbUbQ09cGUOyXVcAS5KNrouxW0r/7IF62Cpxx6ciduk0Q6Saefm2EZ
         XVqcOiLnI7zYYjnawIxWJFwTHoWV8V5j3dtuA=
MIME-Version: 1.0
In-Reply-To: <20101129081639.GA5142@const.bordeaux.inria.fr>
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu>
 <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com>
 <1290954545.13526.27.camel@cai.gentoo> <20101128191152.GV10602@const.famille.thibault.fr>
 <1290993006.877.0.camel@cai.gentoo> <20101129081639.GA5142@const.bordeaux.inria.fr>
From: microcai <microcai@fedoraproject.org>
Date: Mon, 29 Nov 2010 16:20:11 +0800
X-Google-Sender-Auth: vIUkQHXYlHGcgzIOH60IePXWc6U
Message-ID: <AANLkTinmdRjEkmywaMevN5_A=2N8_pBsOAJj8PoAaznz@mail.gmail.com>
Subject: Re: VT console need rewrite
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Microcai <microcai@fedoraproject.org>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-console@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But isn't that basically what you are describing?
>
> (i.e. what's the use of using a pts and /dev/fb, if not for a userlevel
> terminal to actually do the work?)
>

ok, try run zhcon on pts.  can you do that ?
