Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab0GBTvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 15:51:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33790 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756603Ab0GBTvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 15:51:15 -0400
MIME-Version: 1.0
Message-ID: <3c3945c6-6a5d-48f9-bf6e-1e0b19edc2e2@default>
Date: Fri, 2 Jul 2010 12:49:20 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       Konrad Wilk <konrad.wilk@oracle.com>, Jeremy@acsinet12.oracle.com,
       linux-kernel@vger.kernel.org, Don Dutile <ddutile@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: RE: [Xen-devel] Re: [PATCH 0/12] PV on HVM Xen
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
 <20100630175637.GC16488@phenom.dumpdata.com>
 <alpine.DEB.2.00.1007011111510.30135@kaball-desktop>
 <1411749d-666c-447d-bf05-954e2b4adf93@default>
 <alpine.DEB.2.00.1007021132390.29110@kaball-desktop>
 <9d5fb841-26be-4ce1-b549-eb7f17f88e61@default
 alpine.DEB.2.00.1007021810210.29110@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1007021810210.29110@kaball-desktop>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C2E431D.0219:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> >
> > Thanks for the thorough reply!  Any reason that any of these
> > cannot or should not be back-ported to go into 4.0.1?
> 
> They should be safe to backport, the only ones we should be extra
> careful are the TSC related patches, and you were the one to raise that
> complain :)
> If you have some spare time to test 21445 and 21339 on 4.0.1 to make
> sure that everything keeps working as expected, then we can safely
> apply them to xen 4.0 testing.

Thanks, yes, I was putting that task on my list and wasn't sure
what the full set of required changes were and if there were
interdependencies so that I could test on 4.0-testing instead
of on xen-unstable.  (Depending on Keir's 4.0.1 schedule, I
might not get it done in time for 4.0.1 though.)

Dan
