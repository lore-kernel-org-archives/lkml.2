Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969Ab2JaH2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:28:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53741 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab2JaH16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:27:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [PULL REQ] IXP4xx changes for Linux 3.7
Date: Tue, 30 Oct 2012 22:27:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
References: <m3bog6m5iz.fsf@intrepid.localdomain> <m3a9vkahci.fsf@intrepid.localdomain> <20121029082940.GC2527@netboy.at.omicron.at>
In-Reply-To: <20121029082940.GC2527@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210302227.55857.arnd@arndb.de>
X-Provags-ID: V02:K0:jyC0YvX4CQPpR+NccKfgJpvaTZa8hrcRXjirHjMLQMJ
 ZU9Q6ZGoeTpClZgfeADOb6ZjO4uvD7WwugyjJjeH5GJTNTrt3r
 uzM5vsR0+w7TqbbFRD3qdYDQ97ryCiAsVlt3Yd3oEHB8DDBOJA
 vNDTvV/QjCa7NOvpDNZebPNs0Qkyw3zKMvjWPPImyoWW9OFJdj
 CxgpeWViSEa8gpBU5HbJl/hP4L6o7xBDN9msrhKtTmgtqwPGqV
 Nbt+2V0HS+pOrdZ6euJBV++45oGfL0UOysnWuijMrESzOX1Enx
 MRGntTSpmLM0IhYpR+l4KPm/gchQgRD/Tntl5vGO0L1GsO1F8H
 KemY2JylhBf/R9QhM10A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 October 2012, Richard Cochran wrote:
> On Thu, Oct 18, 2012 at 12:01:17AM +0200, Krzysztof Halasa wrote:
> > 
> > Don't get me wrong. If I had time for this it could be different.
> > Unfortunately IXP4xx is a legacy arch, and for me it's simply a hobby at
> > this point. Given the raised barriers to participate, probably aimed at
> > paid maintainers, I have to quit doing this.
> > 
> > BTW since Imre has probably even much less time, it would be a good time
> > to find someone to maintain IXP4xx code. I will be publishing (from time
> > to time) my tree (I'm using the hw myself), so even simple
> > cherry-picking would probably make some sense.
> 
> So if no one else wants to do this, then I am willing to look after
> the IXP code. I think that I do have the time for it.

Thanks for the offer! 

Jason Cooper was also volunteering to help out with this, and even we can't
convince Krzysztof to continue doing it, there is also Imre who is officially
listed as maintainer for IXP4xx and who has not commented on this. As Krzysztof
mentions, he probably doesn't have much time for it, but I'd like to give
him the chance to comment as well.

I'm sure we can find some solution between the four of you. Right now, I think
we should focus on getting the bug fixes from Krzysztof's tree into mainline
and the stable kernels where applicable, and then establish a better working
mode for the future kernels.

	Arnd
