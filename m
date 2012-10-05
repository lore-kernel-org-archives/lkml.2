Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2JEVoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 17:44:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53589 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292Ab2JEVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 17:44:03 -0400
X-Sasl-enc: sQso5FuZkp1WIZPFvLV6wK18HkIoI/ojUq0LmsfpiL6b 1349473442
Date: Fri, 5 Oct 2012 18:43:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: david@lang.hm
Cc: Emmanuel Benisty <benisty.e@gmail.com>, Kurt H Maier <khm@sdf.org>,
        linux-kernel@vger.kernel.org
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121005214358.GA12736@khazad-dum.debian.net>
References: <fa.90I1W/wmSTgRFXVG67o7Pp3+rKA@ifi.uio.no>
 <fa.Oszo+r/ZqdTxC2FHqqg+CRVMJ5Y@ifi.uio.no>
 <fa.CoxzZZId9dJONv353c+pFG/HO8E@ifi.uio.no>
 <fa.ixJ/7D7BnMK8xp7CwikX7jbmnKU@ifi.uio.no>
 <fa./ubRQE7P/T+ateohnOKdDxOFhL4@ifi.uio.no>
 <fa.lpiFTa5CtuIkUf2Z5eJ0YlsNwYI@ifi.uio.no>
 <20121004145022.GA73321@intma.in>
 <CA+i8gKLMtvsR8_aXiNr_Dh8oBw__pSn__ExzRyjG80f4L1u2ng@mail.gmail.com>
 <alpine.DEB.2.02.1210051316180.13407@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1210051316180.13407@asgard.lang.hm>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Oct 2012, david@lang.hm wrote:
> >On Thu, Oct 4, 2012 at 9:50 PM, Kurt H Maier <khm@sdf.org> wrote:
> >>On Wed, Oct 03, 2012 at 07:27:01PM +0000, Al Viro wrote:
> >>>Al, that -><- close to volunteering for maintaining that FPOS kernel-side...
> >>
> >>This would be fantastic.
> >
> >And that would solve this very much worrying issue [1], quoting:
> >"(Yes, udev on non-systemd systems is in our eyes a dead end, in case you
> >haven't noticed it yet. I am looking forward to the day when we can drop
> >that support entirely.)"
> >
> >[1] http://lists.freedesktop.org/archives/systemd-devel/2012-August/006066.html
> 
> I think it's worth noting that even though udev 189 was recently
> released, the not-yet-released Ubuntu 10.10 is going to be including
> udev 175.

So is Debian.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
