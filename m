Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0I2MTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:19:50 -0400
Received: from ist.d-labs.de ([213.239.218.44]:45591 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab0I2MTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:19:47 -0400
Date: Wed, 29 Sep 2010 14:19:45 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: tmhikaru@gmail.com, linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.35.6
Message-ID: <20100929141945.5e28f560@schatten.dmk.lab>
In-Reply-To: <20100929135248.09cd7a84@schatten.dmk.lab>
References: <20100927003608.GA20395@kroah.com>
	<20100927163208.GA4892@roll>
	<20100927215135.3d11d587@schatten.dmk.lab>
	<20100927233956.GA15705@roll>
	<20100928083505.0a808ffd@schatten.dmk.lab>
	<20100928190358.GA24303@roll>
	<20100929092924.2090f19e@schatten.dmk.lab>
	<20100929110247.GA2032@roll>
	<20100929135248.09cd7a84@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 13:52:48 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Wed, 29 Sep 2010 07:02:48 -0400
> tmhikaru@gmail.com wrote:

> > > Yes, the sample rate was one of the things I wanted to know, but also which of
> > > the 3 load figures you were graphing.  
> > To be honest, I actually don't know. I'm *terrible* at regex, this is what
> > the bash script is doing:
> 
> It's taking the first column of the line in  /proc/loadavg which
> corresponds to the 15 min avg on my machine. 

Actually, no. It's the 1 min avg... 

Try using 

awk '{print $3}' /proc/loadavg

but I don't think it necesserily invalidates your bisection results.

Regards,
Flo
