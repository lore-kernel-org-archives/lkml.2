Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0LIU2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:28:50 -0500
Received: from mail.perches.com ([173.55.12.10]:2442 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab0LIU2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:28:49 -0500
Subject: Re: [PATCH 03/15] rtc: Remove duplicate unlikely from IS_ERR
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Alessandro Zummo <a.zummo@towertech.it>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Jiri Kosina <trivial@kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikUTdCRZP9FR1-16MmH4zysKha7m2o_DH6As-HJ@mail.gmail.com>
References: <cover.1291923888.git.joe@perches.com>
	 <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
	 <29ab1782961e5d9b56972818f12eb7a2e5bd4329.1291923889.git.joe@perches.com>
	 <AANLkTikUTdCRZP9FR1-16MmH4zysKha7m2o_DH6As-HJ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 12:28:47 -0800
Message-ID: <1291926527.20677.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-09 at 15:06 -0500, Mike Frysinger wrote:
> On Thu, Dec 9, 2010 at 15:03, Joe Perches wrote:
> > IS_ERR already uses unlikely, remove unlikely from the call sites.
> Tobias already submitted a patch for this.

Thanks Tobias.  Turns out you did them all after all.
Could you please cc linux-kernel for these sorts of patches?

As far as I can tell, the rtc-bfin patch didn't hit lkml,
only the c2port patch did for whatever reason.

The patches aren't marked as an n/m series which would also help
identify the patch scope.  I thought it was a singleton.

Jiri and all others, please ignore my duplicate patchset.

cheers, Joe

