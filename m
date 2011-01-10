Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1AJKRC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 05:17:02 -0500
Received: from imr4.ericy.com ([198.24.6.8]:50198 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1AJKQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 05:16:58 -0500
Date: Mon, 10 Jan 2011 02:16:23 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Juerg Haefliger <juergh@gmail.com>
Subject: Re: linux-next: manual merge of the hwmon-staging tree with the
 jdelvare-hwmon tree
Message-ID: <20110110101623.GA29314@ericsson.com>
References: <20110110132057.bc5d54a0.sfr@canb.auug.org.au>
 <20110110034638.GA28007@ericsson.com>
 <20110110095743.7616b7b3@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110110095743.7616b7b3@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 03:57:43AM -0500, Jean Delvare wrote:
> On Sun, 9 Jan 2011 19:46:38 -0800, Guenter Roeck wrote:
> > On Sun, Jan 09, 2011 at 09:20:57PM -0500, Stephen Rothwell wrote:
> > > Hi Guenter,
> > > 
> > > Today's linux-next merge of the hwmon-staging tree got a conflict in
> > > drivers/hwmon/dme1737.c between commit
> > > b7f2a5c8c9190fcf0126d43972a8ad37eb98f5d0 ("hwmon: (dme1737) Minor
> > > cleanups") from the jdelvare-hwmon tree and commit
> > > 9c6e13b411cf0f656b7d7a78ec35bf0069f631bb ("hwmon: (dme1737) Use pr_fmt
> > > and pr_<level>") from the hwmon-staging tree.
> > > 
> > > Just context changes.  I fixed it up (see below) and can carry the fix as
> > > necessary.
> > > -- 
> > > Cheers,
> > > Stephen Rothwell                    sfr@canb.auug.org.au
> > > 
> > Hi Stephen,
> > 
> > thanks for the note. I suspected that would happen - sorry for the trouble.
> > 
> > Jean, do you want to take Joe's pr_fmt change from my tree and apply it to yours,
> > or should we just wait until the first of the trees was merged into Linus' tree ?
> > If the latter, do you want to send your patches to Linus first, or should I go first ?
> > I am ready to go.
> 
> Let's be good citizens and sort out the conflict before sending the
> patches to Linus. I shall pick the pr_fmt change patch in my own tree.
> 
> But where do I pick it?
> ftp://pub.kernel.org/pub/linux/kernel/people/groeck/linux-staging/ is
> no longer relevant, right? Maybe you can delete it altogether to clear
> up the confusion. Care to point me to somewhere I can download the
> pr_fmt change patch?
> 
Try again; I updated it.

hwmon-next/0007-hwmon-dme1737-Use-pr_fmt-and-pr_-level.patch

In general, I keep my git tree up to date.

git://git.kernel.org/pub/scm/linux/kernel/git/groeck/staging.git

You can get it from there as well.

> As for sending your patches to Linus for 2.6.38, yes, please send them
> as soon as possible. I am still not done processing all the mails I
> received during my vacation, and I must send my i2c patches too, so
> it's better if you don't wait for me and send your patches first.
> 
Ok. Do you want me to take out the dme1737 patch ?

Guenter
