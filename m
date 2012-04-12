Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934780Ab2DLVfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:35:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59814 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2DLVfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <20120412185622.GB2904@burratino>
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
	<20120412185622.GB2904@burratino>
Date: Fri, 13 Apr 2012 00:34:59 +0300
Message-ID: <CAMP44s2M_srvKKaicOpr+TF6hw=dxFMVRwMs2K9E_P_ooPMCXw@mail.gmail.com>
Subject: Re: [ 00/78] 3.3.2-stable review
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Adrian Chadd <adrian@freebsd.org>, Greg KH <gregkh@linuxfoundation.org>,
        Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 9:56 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Felipe Contreras wrote:
>
>> But then are you saying that if upstream is broken (3.4-rc2), then
>> stable should be broken as well (3.3.1), and remain broken until
>> upstream is fixed? I fail to see what would be the point of that.
>
> No, he's saying that when upstream is broken for the same reason as
> stable is, it seems wise to:
>
>  - report upstream
>  - fix your local system
>  - fix any systems you are responsible for
>  - fix upstream
>  - only then fix stable.

I'm not sure those steps were followed for this particular patch on
v3.3.1, but lets assume they where. Now what happens when:

 - you realize the fix made matters worst, in fact, so worst that the
whole thing is unusable in some systems

Presumably we are now in the next round of:

 - fix upstream

But v.3.3.2 is due Friday, which makes it very likely that the fix
won't get in. And what did we gain? If you simplify the situation to
what you explained above, it seems very reasonable, but that's not the
whole picture.

-- 
Felipe Contreras
