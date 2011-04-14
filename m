Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab1DNWOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:14:14 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:44985 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab1DNWOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:14:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19879.29101.783037.726594@pilspetsen.it.uu.se>
Date: Fri, 15 Apr 2011 00:14:05 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Hugh Dickins <hughd@google.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Jens Axboe <jaxboe@fusionio.com>,
        kevin diggs <diggskevin38@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michel Daenzer <michel@daenzer.net>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
In-Reply-To: <BANLkTimykvKp=bwsFyNE9fWqcE9Ffws6bA@mail.gmail.com>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	<1302646173.28876.53.camel@pasglop>
	<1302652502.28876.76.camel@pasglop>
	<19877.23529.745123.819112@pilspetsen.it.uu.se>
	<1302685102.28876.81.camel@pasglop>
	<BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
	<1302736869.28876.91.camel@pasglop>
	<BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>
	<1302771756.15520.100.camel@thor.local>
	<BANLkTimykvKp=bwsFyNE9fWqcE9Ffws6bA@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 14:25:31 -0700, Hugh Dickins wrote:
> Mikael,
> 
> Something worth trying: turn off CONFIG_IDE.  That's what I need to
> boot 2.6.39-rc[1-3] on PowerPC G5.
> 
> I know Jens has been fixing problems with IDE versus his plug/unplug
> changes, but it's still not fixed for me in rc3.
> 
> In other mail http://lkml.org/lkml/2011/4/14/614
> I see Linus recommending his post-rc3 commit 6631e635c65d
> but I've not tried that myself yet.
> 
> Hugh

Hugh,

With CONFIG_IDE disabled I could finally boot 2.6.39-rc3 on my G5.
I lost the DVD drive, but that's fine for now.

Thanks!

/Mikael
