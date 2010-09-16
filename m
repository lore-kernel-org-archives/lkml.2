Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0IPJgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 05:36:01 -0400
Received: from iona.labri.fr ([147.210.8.143]:47389 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab0IPJf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 05:35:59 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Sep 2010 05:35:59 EDT
Message-ID: <4C91E01E.4070209@inria.fr>
Date: Thu, 16 Sep 2010 11:15:10 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
References: <20100915104855.41de3ebf@lilo> <4C90A6C7.9050607@redhat.com> <20100916001232.0c496b02@lilo> <4C91B9E9.4020701@ens-lyon.org>
In-Reply-To: <4C91B9E9.4020701@ens-lyon.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 16/09/2010 08:32, Brice Goglin a écrit :
> I am the guy doing KNEM so I can comment on this. The I/OAT part of KNEM
> was mostly a research topic, it's mostly useless on current machines
> since the memcpy performance is much larger than I/OAT DMA Engine. We
> also have an offload model with a kernel thread, but it wasn't used a
> lot so far. These features can be ignored for the current discussion.

I've just created a knem branch where I removed all the above, and some
other stuff that are not necessary for normal users. So it just contains
the region management code and two commands to copy between regions or
between a region and some local iovecs.

Commands are visible at (still uses ioctls since it doesn't matter while
discussing the features):
https://gforge.inria.fr/scm/viewvc.php/*checkout*/branches/kernel/driver/linux/knem_main.c?root=knem&content-type=text%2Fplain

And the actual driver is at:
https://gforge.inria.fr/scm/viewvc.php/*checkout*/branches/kernel/common/knem_io.h?root=knem&content-type=text%2Fplain

Brice


