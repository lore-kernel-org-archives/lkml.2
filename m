Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1CYNKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:10:03 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48114 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CYNKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:10:01 -0400
Date: Fri, 25 Mar 2011 14:09:59 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110325130959.GA1698@gentoo.trippels.de>
References: <20110324194546.GA1741@gentoo.trippels.de>
 <4D8BA235.7060904@fusionio.com>
 <20110324200613.GA1724@gentoo.trippels.de>
 <4D8BB114.2070002@fusionio.com>
 <20110324214150.GA1739@gentoo.trippels.de>
 <4D8C4304.3050101@fusionio.com>
 <20110325083757.GA1754@gentoo.trippels.de>
 <4D8C55D9.1060903@fusionio.com>
 <20110325095704.GA1694@gentoo.trippels.de>
 <4D8C8E1C.1020304@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C8E1C.1020304@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.25 at 13:44 +0100, Jens Axboe wrote:
> On 2011-03-25 10:57, Markus Trippelsdorf wrote:
> > 
> > Reverting it solves all problems here.
> 
> Can you try this one?

This one doesn't help; I still get the same BUG.

BTW if you're having trouble reproducing this, here is the only non
stock xfs option that I use on the affected partitions:

noatime,logbsize=262144

-- 
Markus
