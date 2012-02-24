Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2BXAJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:09:18 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39986 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab2BXAJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:09:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Miller <davem@davemloft.net>
Subject: Re: 3.3-rc4+: Reported regressions from 3.2
Date: Fri, 24 Feb 2012 01:13:13 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com,
        florian@mickler.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, kernel-testers@vger.kernel.org,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <y44pDJ8xoDC.A.08E.h8rRPB@chimera> <20120223.182825.1031311733171854243.davem@davemloft.net>
In-Reply-To: <20120223.182825.1031311733171854243.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202240113.13575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 24, 2012, David Miller wrote:
> From: "Rafael J. Wysocki" <rjw@sisk.pl>
> Date: Thu, 23 Feb 2012 23:51:20 +0100 (CET)
> 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=42776
> > Subject		: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
> > Submitter	: Meelis Roos <mroos@linux.ee>
> > Date		: 2012-02-13 7:45 (11 days old)
> > Message-ID	: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee>
> > References	: http://marc.info/?l=linux-kernel&m=132911916331615&w=2
> 
> Potential workaround/fix at:
> 
> http://marc.info/?l=linux-kernel&m=132993294018762&w=2

Thanks, updated.

Rafael
