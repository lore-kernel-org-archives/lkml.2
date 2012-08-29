Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab2H2Kke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 06:40:34 -0400
Received: from mail.x86-64.org ([217.9.48.20]:39792 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab2H2Kkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 06:40:32 -0400
Date: Wed, 29 Aug 2012 12:40:18 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, tony.luck@intel.com, andi@firstfloor.org,
        ananth@in.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the
 per-cpu location
Message-ID: <20120829104018.GD26977@aftab.osrc.amd.com>
References: <20120829074154.6755.98941.stgit@localhost.localdomain>
 <20120829101302.GA26977@aftab.osrc.amd.com>
 <503DEE3C.6020406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503DEE3C.6020406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 03:56:04PM +0530, Naveen N. Rao wrote:
> Hmmm.. Can't we just deprecate these? ;) Perhaps we can consider
> adding newer tunables in the right place.

In case you haven't noticed yet: I'm all on your side.

But let me ask you this: these attributes grow to a large number with
a large number of cores but why is this a problem? We have a bunch of
redundant attributes in sysfs, so what?

See what I mean?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
