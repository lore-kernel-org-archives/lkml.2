Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2AKQX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:23:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46261 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab2AKQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:23:23 -0500
MIME-Version: 1.0
In-Reply-To: <7vzkdu7miv.fsf@alter.siamese.dyndns.org>
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com> <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com> <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <7vmx9v7z1r.fsf@alter.siamese.dyndns.org> <CA+55aFx5NATrpLnkMiV2vAxSAJPK7wkY2vyHbyeZGgT9+jP06w@mail.gmail.com>
 <7vehv77xeq.fsf@alter.siamese.dyndns.org> <CA+55aFzuGtJkQFDooSGWQ2_NiJVHN2E7S5dmOnWTYn8_s8Gg3g@mail.gmail.com>
 <7vzkdu7miv.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Jan 2012 08:23:01 -0800
X-Google-Sender-Auth: x7lpfQ3WB0_YcDUmbICwHR-iPA8
Message-ID: <CA+55aFy679Skqi_D3x8=M=mwZiViMX9EbZrqP11riiLb_Hzb9g@mail.gmail.com>
Subject: Re: Re* Regulator updates for 3.3
To: Junio C Hamano <gitster@pobox.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Git Mailing List <git@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 10:59 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> What makes me uneasy about the idea of running the editor by default is
> that many people still use Git as a better CVS/SVN. Their workflow is to
> build randomly on their 'master', attempt to push and get rejected, pull
> only so that they can push out, and then push the merge result out.

Sure. And I don't think we can do much about it. They'll either set
the legacy flag, or they'll just exit the editor without adding
anything useful (if you come from a CVS background in particular, you
probably never learnt to do good commit logs anyway).

So it will be a bit more work for the bad workflow, I agree - although
if it really irritates people, they can just set that GIT_MERGE_LEGACY
in their .bashrc files or something. But we can *hope* that even those
people might sometimes actually talk about what/why they are doing
things, or maybe even learn about that whole "distributed" thing.

I agree that is unlikely to ever happen, though. It's more likely that
they will change their aliases so that their "update" command just
adds the --no-edit flag. Regardless, it doesn't sound *too* onerous to
work around.

Patch looks good to me. I would personally have compared "st_mode"
instead of (or in addition to) "st_rdev", but I don't think it matters
all that much.

                                 Linus
