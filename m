Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0IVJqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:46:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:50173 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0IVJqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:46:15 -0400
Date: Wed, 22 Sep 2010 11:46:12 +0200
From: Florian Mickler <florian@mickler.org>
To: Meelis Roos <mroos@linux.ee>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
Message-ID: <20100922114612.6eeae729@schatten.dmk.lab>
In-Reply-To: <alpine.SOC.1.00.1009221148550.14750@math.ut.ee>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera>
	<Wn2eLj_6KZG.A.SpH.KF7lMB@chimera>
	<alpine.SOC.1.00.1009221148550.14750@math.ut.ee>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 11:50:03 +0300 (EEST)
Meelis Roos <mroos@linux.ee> wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2010-08-19 21:03 (33 days old)
> > Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> > References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> 
> Still present. The maintainer of the driver has a patch that I have 
> tested, and for quite some time now, but it still does not appear in 
> mainline.
> 

Do you have a pointer to the maintainer and the patch, so that we can
update the bugzilla entry and ping the maintainer? 
