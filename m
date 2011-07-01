Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab1GAScc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:32:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49214 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1GAScb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:32:31 -0400
Date: Fri, 1 Jul 2011 20:32:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, rjw@sisk.pl
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Message-ID: <20110701183227.GF23059@one.firstfloor.org>
References: <20110701170531.GA3693@tassilo.jf.intel.com> <20110701181406.GA1614@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701181406.GA1614@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:14:06PM -0400, Dave Jones wrote:
> On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
> 
>  > I found I can reliably crash a 3.0 system by pulling the
>  > USB cable of a mounted USB cdrom (or rather a USB device which
>  > has a builtin fake CD-ROM) 
>  > 
>  > I suspect it's a regression too.
> 
> We've been seeing a lot of similar bugs in Fedora since we pushed
> a 2.6.38.8 update.  Some of the traces are different, but some

I've also seen one with an earlier kernel where the NULL 
reference was in elv_.* something.  Don't have a written down backtrace
for this, but perhaps you have.

-Andi
