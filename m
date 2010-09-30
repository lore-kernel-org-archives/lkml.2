Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0I3F3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 01:29:31 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41717 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab0I3F3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 01:29:30 -0400
Date: Thu, 30 Sep 2010 07:29:27 +0200
From: Florian Mickler <florian@mickler.org>
To: tmhikaru@gmail.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: Linux 2.6.35.6
Message-ID: <20100930072927.77f0f79b@schatten.dmk.lab>
In-Reply-To: <20100930013305.GA23569@roll>
References: <20100927003608.GA20395@kroah.com>
	<20100927163208.GA4892@roll>
	<20100927215135.3d11d587@schatten.dmk.lab>
	<20100927233956.GA15705@roll>
	<20100928083505.0a808ffd@schatten.dmk.lab>
	<20100928190358.GA24303@roll>
	<20100929092924.2090f19e@schatten.dmk.lab>
	<20100929110247.GA2032@roll>
	<20100929135248.09cd7a84@schatten.dmk.lab>
	<20100930013305.GA23569@roll>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 21:33:05 -0400
tmhikaru@gmail.com wrote:

> On Wed, Sep 29, 2010 at 01:52:48PM +0200, Florian Mickler wrote:
> > In all cases, you can simply do the bisection based on the 'load
> > average' criteria and then later check if the changeset that you've
> > found that way also influences the kernel compile times. 
> Works for me.
> 
> > Out of curiosity, what region are you circling in?
> git log says I'm at

git-log is not that expressive here, as it only shows the history of
current HEAD (the currently checked out version). You can post the
output of 'git bisect log'. 
If you wanna know how the region looks like you can type 'git bisect
visualize'. 

Regards,
Flo
