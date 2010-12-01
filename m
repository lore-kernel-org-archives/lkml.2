Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0LAQmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 11:42:07 -0500
Received: from catholic.ebb.org ([67.207.139.67]:54807 "EHLO catholic.ebb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178Ab0LAQmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 11:42:05 -0500
X-Greylist: delayed 444 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 11:42:05 EST
From: "Bradley M. Kuhn" <bkuhn@ebb.org>
To: david@lang.hm
Cc: Pavel Machek <pavel@ucw.cz>, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Perez-Gonzalez\, Inaky" <inaky.perez-gonzalez@intel.com>,
        Charles Marker <Charles.Marker@atheros.com>,
        Jouni Malinen <Jouni.Malinen@atheros.com>,
        Kevin Hayes <kevin@atheros.com>, Zhifeng Cai <zhifeng.cai@atheros.com>,
        Don Breslin <Don.Breslin@atheros.com>,
        Doug Dahlby <Doug.Dahlby@atheros.com>, Julia Lawall <julia@diku.dk>
Subject: Re: Challenges with doing hardware bring up with Linux first
Organization: Opinions expressed in this email are my own and are not necessarily those of any organization with which I have an affiliation.
References: <AANLkTim4jVaZxYp8nSgJyy28iwxcxbPeNUzxTfoHAX4S@mail.gmail.com>
	<20101118113441.74fcdc21@lxorguk.ukuu.org.uk>
	<AANLkTikOZbtyhsk0OBb4OdUi6qj-7k_hU-aW_Pkhfpq0@mail.gmail.com>
	<20101130192648.GA1623@ucw.cz>
	<AANLkTinMyAeVJJc7Lc-vt_Ywr+vcSf-GAiQwggTGbqh8@mail.gmail.com>
	<20101130200019.GA28735@elf.ucw.cz>
	<alpine.DEB.2.00.1011301209090.423@asgard.lang.hm>
X-No-Archive: yes
X-Disclaimer: Opinions expressed in this email are my own and are not necessarily those of any organization with which I have an affiliation.
X-Archive: no
Date: Wed, 01 Dec 2010 11:02:52 -0500
In-Reply-To: <alpine.DEB.2.00.1011301209090.423@asgard.lang.hm>
	(david@lang.hm's message of "Tue, 30 Nov 2010 12:13:05 -0800 (PST)")
Message-ID: <87hbex1nwz.fsf@ebb.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume someone started cc'ing me on this thread to get my opinion as a
non-lawyer GPL geek.

david@lang.hm wrote:
> However, there are quite a few files in the kernel that are BSD
> licensed, when combined with other GPL code, the only way you can
> re-distribute the result is under the GPL, so it is effectivly
> 'converted' when you compile, but by leaving the file BSD,
> improvements to it can be shared back with the original authors and
> put into their main codebase, so it's actually more polite to leave
> the license as-is for this file.

FWIW, I agree more or less completely with the above.  I think the
implications are the same for ISC as well, as Luis points out elsewhere
in the thread.
-- 
   -- bkuhn
