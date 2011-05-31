Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1EaKTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:19:49 -0400
Received: from verein.lst.de ([213.95.11.211]:44687 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab1EaKTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:19:48 -0400
Date: Tue, 31 May 2011 12:19:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
Message-ID: <20110531101947.GA31648@lst.de>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org> <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com> <20110530130949.GB13494@lst.de> <BANLkTikdJcNPv4CV4nLuyuPtAYpCR1cp0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikdJcNPv4CV4nLuyuPtAYpCR1cp0Q@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 05:13:22PM +0200, Bart Van Assche wrote:
> On Mon, May 30, 2011 at 3:09 PM, Christoph Hellwig <hch@lst.de> wrote:
> > Given that we pretty well tested and working code that's used in lots
> > of production setups my vote is for taking it as-is unless someone can
> > actually show a prototype for a nicely working user/kernel split.
> 
> As far as I know such a user/kernel split has been implemented in both
> IET and SCST and is working fine in both of these projects.

Which are unrelated codebases - if you want to offer a competing iSCSI
implementation for the core target framework we have in mainline based
on the codebase go ahead.

> And here is another issue that still hasn't been resolved yet:
> http://marc.info/?l=linux-scsi&m=129707890023739&w=2.

This is related to the software iSCSI fronted in what way?

