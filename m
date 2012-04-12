Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966143Ab2DLVoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:44:08 -0400
Received: from 1wt.eu ([62.212.114.60]:65086 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966099Ab2DLVoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:44:06 -0400
Date: Thu, 12 Apr 2012 23:43:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120412214336.GB12807@1wt.eu>
References: <20120412002927.GA23167@kroah.com> <CAMP44s3Jh-t07A+i82qbAMQyEN0oWTmKk5BJcst942gFdD0=VA@mail.gmail.com> <20120412011313.GA23764@kroah.com> <CAMP44s2q+bQE3-zsX4bs=sQDt4jf8eE5bwZ8V88UjodjRyAjog@mail.gmail.com> <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120412185622.GB2904@burratino> <CAMP44s2M_srvKKaicOpr+TF6hw=dxFMVRwMs2K9E_P_ooPMCXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2M_srvKKaicOpr+TF6hw=dxFMVRwMs2K9E_P_ooPMCXw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 12:34:59AM +0300, Felipe Contreras wrote:
> Now what happens when:
> 
>  - you realize the fix made matters worst, in fact, so worst that the
> whole thing is unusable in some systems
> 
> Presumably we are now in the next round of:
> 
>  - fix upstream
> 
> But v.3.3.2 is due Friday, which makes it very likely that the fix
> won't get in. And what did we gain? If you simplify the situation to
> what you explained above, it seems very reasonable, but that's not the
> whole picture.

BTW, if you're so in need for critical fixes, why do you jump to the latest
version ? It's known and accepted that stable versions stabilize over time
with a few random hiccups during their early stage. You could have chosen
3.0 instead which generally holds some fixes that cooked longer before being
merged.

There's a cost at living on the bleeding edge. It's fun and sometimes it
hurts but that should not be that dramatic that you spend so many emails
telling how stable releases should be maintained.

Willy

