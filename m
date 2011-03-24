Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab1CXUGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:06:17 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:41323 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1CXUGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:06:15 -0400
Date: Thu, 24 Mar 2011 21:06:13 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
Message-ID: <20110324200613.GA1724@gentoo.trippels.de>
References: <4D8B4A89.80608@fusionio.com>
 <20110324183019.GA1676@gentoo.trippels.de>
 <4D8B8F34.5000203@fusionio.com>
 <4D8B92AE.8090308@fusionio.com>
 <20110324185445.GB1696@gentoo.trippels.de>
 <4D8B9457.2020608@fusionio.com>
 <20110324193441.GA1723@gentoo.trippels.de>
 <4D8B9D2F.4010504@fusionio.com>
 <20110324194546.GA1741@gentoo.trippels.de>
 <4D8BA235.7060904@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8BA235.7060904@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.03.24 at 20:57 +0100, Jens Axboe wrote:
> 
> OK, still a data point. What was the last -git kernel you used?

This one was the last and gave me no problems:

commit b81a618dcd3ea99de292dbe624f41ca68f464376
Merge: 2f284c8 a9712bc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Mar 23 20:51:42 2011 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6

-- 
Markus
