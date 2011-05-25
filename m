Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1EYJJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:09:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43949 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1EYJJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mmXHbVx1sojB6ISUAi4S44lH1grG7sk/UslzQY7EDrJ75WR4JSKtawpKokIpWtnzxa
         G4tavVn+JrxxKn2nhWYY5XBy35iyoCJqGm4eNlhyYO9mQc4Ew0o/VzeibJJTjf64QilG
         qjCnoPMNtaF5/N5PiuR+pKTbA6ihzQP8CyyBg=
Date: Wed, 25 May 2011 11:09:27 +0200
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [57/71] block: rescan partitions on invalidated devices on
 -ENOMEDIA too
Message-ID: <20110525090927.GD10146@htj.dyndns.org>
References: <20110519180626.GA16555@kroah.com>
 <20110519180559.722522150@clark.kroah.org>
 <BANLkTi=dKXo=TeTU7a--r3YCxrptNU3VVg@mail.gmail.com>
 <20110519181814.GA17816@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110519181814.GA17816@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Thu, May 19, 2011 at 11:18:14AM -0700, Greg KH wrote:
> On Thu, May 19, 2011 at 08:12:44PM +0200, Tejun Heo wrote:
> > Can you please hold this for a while?  It causes an extra warning
> > message to be printed during device detection.  It isn't harmful but
> > still.  I'll soon send a patch to resolve the issue and it would be
> > better for them to go together.
> 
> Sure, I've dropped this one for now.  Let me know when I should add it
> back to the next round of stable releases.

ff2a9941ca (block: move bd_set_size() above rescan_partitions() in
__blkdev_get()) which fixes the warning is now in mainline.  Please
apply this and ff2a9941ca to the next -stable.  I also noted it in the
commit message of ff2a9941ca.

Thanks.

-- 
tejun
