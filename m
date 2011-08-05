Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1HEQwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 12:52:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab1HEQwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 12:52:01 -0400
Date: Fri, 5 Aug 2011 12:51:20 -0400
From: Dave Jones <davej@redhat.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
Message-ID: <20110805165119.GA11593@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jaxboe@fusionio.com>
References: <20110805010038.GA18148@redhat.com>
 <20110805084614.GA1588@x4.trippels.de>
 <CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
 <alpine.DEB.2.00.1108051131440.28580@router.home>
 <20110805163948.GA11113@redhat.com>
 <alpine.DEB.2.00.1108051146180.28580@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108051146180.28580@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 11:47:56AM -0500, Christoph Lameter wrote:
 > On Fri, 5 Aug 2011, Dave Jones wrote:
 > 
 > > Not sure if you were addressing my original report (quoted above), or the networking
 > > related report in this part of the thread. But anyway, I had it turned on (as well as just about
 > > every other debugging option).  I didn't see anything output from it though,
 > > just the LIST_DEBUG warnings.
 > 
 > But CONFIG_SLUB_DEBUG_ON was off? If slab debugging was on then this could
 > be an issue with full slab list management instead of partial lists.

$ grep SLUB_DEBUG_ON .config
CONFIG_SLUB_DEBUG_ON=y

	Dave

