Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0KTAZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 19:25:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab0KTAZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 19:25:07 -0500
Date: Fri, 19 Nov 2010 16:08:56 -0800
From: Greg KH <gregkh@suse.de>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        davem@davemloft.net, jesse@nicira.com
Subject: Re: [Stable-review] [00/66] 2.6.36.1-stable review
Message-ID: <20101120000856.GB17354@suse.de>
References: <20101119220309.GA15562@kroah.com>
 <20101119221856.GB2095@nik-comp.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119221856.GB2095@nik-comp.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 11:18:56PM +0100, Nikola Ciprich wrote:
> Hi Greg,
> I guess it's certainly quite late for it now, but would You be willing
> to accept this one for 2.6.36.1 too?
> 
> http://www.spinics.net/lists/netdev/msg146227.html
> 
> fixes:
> https://bugzilla.kernel.org/show_bug.cgi?id=20462
> 
> It's been submitted to stable, but for some reason it was omited...

There's been a lot of patches submitted that didn't make it into .36.1
due to time constraints and the already-large patch queue size.

I have a lot pending that will show up in .36.2.  If you don't see it
there, please remind me again.

But note, networking patches get sent to me by the network subsystem
maintainer.  Please work with David to get that into the stable tree,
he's the one who needs to send this to me.

thanks,

greg k-h
