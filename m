Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279Ab1HIUPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:15:24 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:23408 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1HIUPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:15:23 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 16:15:23 EDT
Date: Tue, 9 Aug 2011 15:09:54 -0500
From: scameron@beardog.cce.hp.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Cameron <stephenmcameron@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
        thenzl@redhat.com, akpm@linux-foundation.org, axboe@kernel.dk
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering problem
Message-ID: <20110809200954.GH27723@beardog.cce.hp.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com> <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com> <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com> <1312920391.8648.6.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312920391.8648.6.camel@mulgrave>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 03:06:31PM -0500, James Bottomley wrote:
> On Tue, 2011-08-09 at 14:58 -0500, Stephen Cameron wrote:
> > On Tue, Aug 9, 2011 at 8:33 AM, Stephen Cameron
> > <stephenmcameron@gmail.com> wrote:
> > 
> > > Despite the above patch, which I do think is correct, I can still get
> > > a panic (on RHEL 6.1 with 2.6.31-rc1 kernel)
> > 
> > Er, I meant 3.1-rc1, not 2.6.31-rc1.
> 
> Do I take it from the fact that you cc'd stable that you want these
> patches in the stable tree in spite of not adding the stable tag?
> 
> James
> 

Well, I obviously don't know how to CC stable properly.
I think I will stop since it only seems to annoy Greg
and make me feel like an idiot for trying.

-- steve

