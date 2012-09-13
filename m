Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2IMVfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 17:35:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45410 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2IMVfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 17:35:38 -0400
Date: Thu, 13 Sep 2012 22:35:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Paolo Giarrusso <p.giarrusso@gmail.com>
Cc: fs_hfs@kernel-bugs.osdl.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: Linux hfsplus corrupts chflags bits?
Message-ID: <20120913213535.GA21642@srcf.ucam.org>
References: <CAAcnjCR2c0qVCJEwH91ajnZ_vKHNFiUv8EUUU7x9ZTD+L5nOBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAcnjCR2c0qVCJEwH91ajnZ_vKHNFiUv8EUUU7x9ZTD+L5nOBg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a similar problem with the userflags field - we were writing 
random data. It wouldn't surprise me if this is another case where a 
field is just not being initiaised.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
