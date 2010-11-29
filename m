Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0K2I6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 03:58:32 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11411
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751950Ab0K2I6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 03:58:31 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Nov 2010 03:58:30 EST
X-IronPort-AV: E=Sophos;i="4.59,275,1288566000"; 
   d="scan'208";a="80371732"
Date: Mon, 29 Nov 2010 09:58:29 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Microcai <microcai@fedoraproject.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lisa Milne <lisa@ltmnet.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: VT console need rewrite
Message-ID: <20101129085829.GM5142@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Microcai <microcai@fedoraproject.org>, Ted Ts'o <tytso@mit.edu>,
	Lisa Milne <lisa@ltmnet.com>,
	"jonsmirl@gmail.com" <jonsmirl@gmail.com>,
	linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1290941875.13526.15.camel@cai.gentoo> <73BC440E-833E-4E1B-ACCC-5D68BAB89D83@mit.edu> <1290951770.13526.18.camel@cai.gentoo> <AANLkTimQDWHo4-8-H+5bB_uzrgzU=gqbDBuerq983moR@mail.gmail.com> <20101129020610.7ea7c79e.lisa@ltmnet.com> <1290961207.13526.31.camel@cai.gentoo> <20101128194624.GP2767@thunk.org> <1290993244.877.3.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290993244.877.3.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microcai, le Mon 29 Nov 2010 09:14:04 +0800, a écrit :
> Hey, my old patch already did it , and do not break any old stuff.

To your knowledge.  IIRC while reading your patch I found a couple of
things that would most probably break some corner cases, which could
go unnoticed, that's why I proposed to first extend the internal vc
content matrix into unicode values, so as to clearly have to upgrade all
drivers.

Samuel
