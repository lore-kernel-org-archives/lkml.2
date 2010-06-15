Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0FOOx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:53:29 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33410 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757762Ab0FOOx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:53:27 -0400
Date: Tue, 15 Jun 2010 09:49:34 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alex Shi <alex.shi@intel.com>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #15713] hackbench regression due to commit 9dfc6e68bfe6e
In-Reply-To: <YPGdyfWGvNK.A.Y9.U8OFMB@chimera>
Message-ID: <alpine.DEB.2.00.1006150949100.6625@router.home>
References: <g77CuMUl7QI.A.5wF.V5OFMB@chimera> <YPGdyfWGvNK.A.Y9.U8OFMB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been addressed by moving the per node information into a
different cacheline.

On Sun, 13 Jun 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15713
> Subject		: hackbench regression due to commit 9dfc6e68bfe6e
> Submitter	: Alex Shi <alex.shi@intel.com>
> Date		: 2010-03-25 8:40 (81 days old)
> First-Bad-Commit: http://git.kernel.org/linus/9dfc6e68bfe6ee452efb1a4e9ca26a9007f2b864
> Message-ID	: <1269506457.4513.141.camel@alexs-hp.sh.intel.com>
> References	: http://marc.info/?l=linux-kernel&m=126950632920682&w=4
> Handled-By	: Christoph Lameter <cl@linux-foundation.org>
> 		  Pekka Enberg <penberg@cs.helsinki.fi>
>
>
>
>
