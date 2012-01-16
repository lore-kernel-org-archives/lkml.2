Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2APPwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:52:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab2APPwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:52:20 -0500
Date: Mon, 16 Jan 2012 16:50:17 +0100
From: Andrew Jones <drjones@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, mingo@elte.hu, david.woodhouse@intel.com,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, arnd@arndb.de,
        holt@sgi.com, linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120116155004.GA6999@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <4F1444FF.60205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1444FF.60205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 04:40:47PM +0100, Jerome Marchand wrote:
> > @@ -1259,8 +1259,7 @@ config SLUB
> >  	   a slab allocator.
> >  
> >  config SLOB
> > -	depends on EXPERT
> > -	bool "SLOB (Simple Allocator)"
> > +	bool "SLOB (Simple Allocator)" if EXPERT
> >  	help
> >  	   SLOB replaces the stock allocator with a drastically simpler
> >  	   allocator. SLOB is generally more space efficient but
> 
> Am I missing something or this particular chunk does not actually change
> anything?
> 

No, you're correct. There's no actual change, so the hunk could be dubbed
as an unnecessary cleanup. I made the change in order to give it the same
general format as the rest of the expert options in that file.

Drew
