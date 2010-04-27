Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0D0FVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 01:21:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0D0FVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 01:21:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HeBnG4l1OXUYQr8BNqeXBZwsriuGcxIP2ghna39fY7fSFzt+GL125z0aFv3REaIFz+
         chSxZ0DtHuKX/0zCOkjQr/Sb8Q4poWV2uTgpt0X1z05Y9myPYrdJFUiQFoqDB+om8+a9
         6JZ1c7AcQUdKgTstNHmUab80EftwBlbFklhg8=
Date: Tue, 27 Apr 2010 07:21:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linux Next <linux-next@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: A few tree inclusion update requests
Message-ID: <20100427052109.GG5695@nowhere>
References: <20100410134221.GC5204@nowhere> <20100413094618.76ac20a8.sfr@canb.auug.org.au> <20100427025530.GE5695@nowhere> <20100427151035.c727c9e5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427151035.c727c9e5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 03:10:35PM +1000, Stephen Rothwell wrote:
> Hi Frederic,
> 
> On Tue, 27 Apr 2010 04:55:32 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >
> > Could you please integrate the following new tree in linux-next?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> > 	bkl/ioctl
> 
> Added from today.


Thanks.

And your conflict fixes against its merge look all right.

