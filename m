Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab1GASO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:14:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1GASOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:14:24 -0400
Date: Fri, 1 Jul 2011 14:14:06 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        rjw@sisk.pl
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110701181406.GA1614@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, axboe@kernel.dk, rjw@sisk.pl
References: <20110701170531.GA3693@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701170531.GA3693@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:

 > I found I can reliably crash a 3.0 system by pulling the
 > USB cable of a mounted USB cdrom (or rather a USB device which
 > has a builtin fake CD-ROM) 
 > 
 > I suspect it's a regression too.

We've been seeing a lot of similar bugs in Fedora since we pushed
a 2.6.38.8 update.  Some of the traces are different, but some
look to be the same as yours. (here's one for eg: https://bugzilla.redhat.com/show_bug.cgi?id=712830)

The common cause seems to be 'device went away'. So USB CD drives,
USB memory sticks, and for some reason virtualbox shutdown.

	Dave

