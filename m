Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0HXOz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:55:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34980 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0HXOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:55:24 -0400
Date: Tue, 24 Aug 2010 08:55:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Pasi K?rkk?inen <pasik@iki.fi>, Chetan Loke <chetanloke@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        scst-devel <scst-devel@lists.sourceforge.net>
Subject: Re: Linux I/O subsystem performance (was: linuxcon 2010...)
Message-ID: <20100824145522.GQ12892@parisc-linux.org>
References: <4C701E08.2020005@vlnb.net> <1282423398.3015.39.camel@mulgrave.site> <AANLkTikcReFsYMhs1RkCHoRkL1+Q9WuptHj1xbx49YsA@mail.gmail.com> <1282508953.3042.102.camel@mulgrave.site> <4C727BEB.9020100@scalableinformatics.com> <AANLkTim-M6dfLvJQnbieFqZCGG33E+-i+u_soCq2p9f1@mail.gmail.com> <AANLkTinDY8hEABHaPsCC+3wGMCn0ZLcyfDa9U9jXJ3d4@mail.gmail.com> <AANLkTim+fj-OL+Bixfbrxv6AgSVv_NpT-KdG6vrc6ub-@mail.gmail.com> <20100824072557.GK2804@reaktio.net> <4C73DA91.9040101@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C73DA91.9040101@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 06:43:29PM +0400, Vladislav Bolkhovitin wrote:
> Also it looks very suspicious why nobody even tried to match that  
> Microsoft/Intel record, even Intel itself who closely works with Linux  
> community in the storage area and could do it using the same hardware.

You seem to be under the impression that "Intel" is some monolithic
entity.  Despite working with six different storage & performance
groups within Intel, I have no idea what record you're referring to,
nor what hardware it was accomplished with.  Even if I did, I wouldn't
know which group within Intel to contact to see if they still have
the setup.  Then I'd have to convince them that it's in their interest
to try to replicate this on Linux.  And I'd have to be prepared to sink
a considerable quantity of my time into it ... which I don't have.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
