Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab0JKMvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:51:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45683 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab0JKMvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UGP+r5R7kFcvp2NboxoaNnpE05c8FGr7gdN4miBz2pb41c7/kDckhOogEmAWpVE2wa
         u/EtIn1GvCE1+XKCgDLJOfQo/YJzdMheJUt2HmT1kT8BMEIDEhr5gAnNkhY9d68eghBc
         Rh3LzhMTIEyY2uDJ5Hn7YBxs6CR7jpBpIQG5I=
Date: Mon, 11 Oct 2010 16:50:56 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: kernel-janitors@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8804: fix error handling code
Message-ID: <20101011125056.GA25041@albatros>
References: <1286731745-18169-1-git-send-email-segooon@gmail.com>
 <20101011120014.GJ9231@rakim.wolfsonmicro.main>
 <20101011121555.GA32652@albatros>
 <20101011123609.GL9231@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011123609.GL9231@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 13:36 +0100, Mark Brown wrote:
> On Mon, Oct 11, 2010 at 04:15:55PM +0400, Vasiliy Kulikov wrote:
> > On Mon, Oct 11, 2010 at 13:00 +0100, Mark Brown wrote:
> 
> > > ...it's not clear to me that this change is an improvement - it'll make
> > > the driver more fragile in the face of errors, I don't see a benefit in
> > > refusing to register the variant for one bus if the other fails?
> 
> > I tried to implement your variant with depca driver in past, but it was
> > rejected by David Miller:
> > http://lists.openwall.net/netdev/2010/07/12/9
> 
> I disagree with David here, and in any case if you're going to make a
> style change like this they really ought to be applied over all drivers
> rather than just a few individual ones.

It is not greppable situation to simply change the behavior of all
drivers.  I was looking for memory leak bugs in drivers/net/ and fixed
some of them.  Manual looking through _all_ drivers takes much more
time.  In general I try to search for repeatable bugs with coccinelle,
but it is rare case.


Thanks,

-- 
Vasiliy
