Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab0HES7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080Ab0HES7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:59:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, Valdis.Kletnieks@vt.edu,
        josef@redhat.com,
        Michael Monnerie <michael.monnerie@is.it-management.at>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: direct-io regression [Was: How to track down abysmal performance ata - raid1 - crypto - vg/lv - xfs]
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
	<20100804085039.GA11671@infradead.org>
	<20100804091317.GA27779@isilmar-3.linta.de>
	<20100804092122.GA2998@infradead.org>
	<20100804073546.GA7494@comet.dominikbrodowski.net>
	<201008041116.09822@zmi.at>
	<20100804102526.GB13766@isilmar-3.linta.de>
	<15446.1280953986@localhost>
	<20100805093100.GA3001@comet.dominikbrodowski.net>
	<20100805113240.GA29846@think>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 05 Aug 2010 14:58:37 -0400
In-Reply-To: <20100805113240.GA29846@think> (Chris Mason's message of "Thu, 5
	Aug 2010 07:32:40 -0400")
Message-ID: <x49tyn8c2ea.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason <chris.mason@oracle.com> writes:

> But, I'm surprised your drive is doing 8K dio reads at 16MB/s, that
> seems a little high.  

I'm not sure why you think that.  We're talking about a plain old SATA
disk, right?  I can get 40-50MB/s on my systems for 8KB O_DIRECT reads.
What am I missing?

Cheers,
Jeff
