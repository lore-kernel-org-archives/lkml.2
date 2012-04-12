Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944Ab2DLS4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:56:30 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40177 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2DLS42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:56:28 -0400
Date: Thu, 12 Apr 2012 13:56:22 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412185622.GB2904@burratino>
References: <20120411231102.GA6404@kroah.com>
 <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com>
 <20120412002927.GA23167@kroah.com>
 <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com>
 <20120412011313.GA23764@kroah.com>
 <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com>
 <20120412144626.GA14868@kroah.com>
 <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com>
 <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
 <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras wrote:

> But then are you saying that if upstream is broken (3.4-rc2), then
> stable should be broken as well (3.3.1), and remain broken until
> upstream is fixed? I fail to see what would be the point of that.

No, he's saying that when upstream is broken for the same reason as
stable is, it seems wise to:

 - report upstream
 - fix your local system
 - fix any systems you are responsible for
 - fix upstream
 - only then fix stable.

That way, the user doesn't get the disconcerting experience of getting
and then losing the fix when upgrading first to the next stable
version, then to the next upstream version.

Makes sense?

Hope that helps,
Jonathan
