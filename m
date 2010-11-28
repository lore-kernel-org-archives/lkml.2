Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0K1TL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 14:11:56 -0500
Received: from solo.fdn.fr ([80.67.169.19]:55855 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0K1TLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 14:11:55 -0500
Date: Sun, 28 Nov 2010 20:11:52 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Microcai <microcai@fedoraproject.org>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>, Theodore Tso <tytso@mit.edu>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101128191152.GV10602@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Microcai <microcai@fedoraproject.org>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	linux-console@vger.kernel.org
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <1290954545.13526.27.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290954545.13526.27.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai, le Sun 28 Nov 2010 22:29:05 +0800, a écrit :
> So, here is the design according to your description  .. 
> 
> JUST export /dev/fb and /dev/pts and /dev/console
> The kernel use /dev/console, but invisible. 
> The rest of the world uses /dev/pts
> 
> Make init using /dev/fb to display boot message, and agetty runs
> on /dev/pts

Errr, but that already exists, that's fbterm...

Samuel
