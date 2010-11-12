Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0KLPMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:12:21 -0500
Received: from bunsen.bytemark.co.uk ([80.68.81.6]:45102 "EHLO
	bunsen.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab0KLPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:12:20 -0500
Date: Fri, 12 Nov 2010 10:11:53 -0500
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/17] Series short description
Message-ID: <20101112151153.GU3891@flamenco.cs.columbia.edu>
References: <20101028175615.GA2367@kroah.com>
 <20101112111359.11631.84086.stgit@ES-BJ21R4J>
 <4CDD23A1.4000707@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDD23A1.4000707@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 11:23:13 +0000, Martyn Welch wrote:
> Hi Greg,
> 
> Here's the series of patches from Emilio I have been through and Acked.
> 
> Sorry for not sending this sooner, bad health kept me from work. I have
> promised to work through the remaining patches for Emilio, however the
> absence from work and work commitments means this is going to take a
> little longer than I had hoped (sorry Emilio). It is on my "todo" list.

Don't worry, as I said there's no rush in getting this merged (in
production we're still using a fairly old kernel).

Hope you're well now.

> I have applied minor edits to some of the patches to remove checkpatch
> warnings, stacked git has the habit of correcting chunk offsets (which
> may occur when re-ordering patches etc.), but I believe the others are
> as sent by Emilio (with the addition of my ack).

Just FYI, if those checkpatch warnings were about lines exceeding 80
characters, I consciously ignored them. After reading this[1] message I
stopped trimming long lines, especially if they're just a few characters
over the magic number.

Anyway this is just code formatting, either way is fine with me.

Thanks,

		Emilio

[1] http://lkml.org/lkml/2009/12/17/229

