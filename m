Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2HAJPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 05:15:18 -0400
Received: from osrc3.amd.com ([217.9.48.20]:36085 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab2HAJPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 05:15:16 -0400
Date: Wed, 1 Aug 2012 11:15:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [RESEND PATCH 0/5 V2] x86: mce: Bugfixes, cleanups and a new
 CMCI poll version
Message-ID: <20120801091507.GC7379@aftab.osrc.amd.com>
References: <1342720781-4729-1-git-send-email-gong.chen@linux.intel.com>
 <20120801005610.GA23536@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120801005610.GA23536@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:56:10AM +0800, Chen Gong wrote:
> On Thu, Jul 19, 2012 at 01:59:36PM -0400, Chen Gong wrote:
> > Date:	Thu, 19 Jul 2012 13:59:36 -0400
> > From: Chen Gong <gong.chen@linux.intel.com>
> > To: tglx@linutronix.de
> > Cc: tony.luck@intel.com, bp@amd64.org, x86@kernel.org,
> > 	linux-kernel@vger.kernel.org
> > Subject: [RESEND PATCH 0/5 V2] x86: mce: Bugfixes, cleanups and a new
> >  CMCI poll version
> > X-Mailer: git-send-email 1.7.10.4
> > 
> > [PATCH 1/5] x86: mce: Disable preemption when calling raise_local()
> > [PATCH 2/5] x86: mce: Serialize mce injection
> > [PATCH 3/5] x86: mce: Split timer init
> > [PATCH 4/5] x86: mce: Remove the frozen cases in the hotplug code
> > [PATCH 5/5] x86: mce: Add cmci poll mode
> > 
> > The following series fixes a few interesting bugs (found by review in
> > context of the CMCI poll effort) and a cleanup to the timer/hotplug
> > code followed by a consolidated version of the CMCI poll
> > implementation. This series is based on Linus' tree.
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > 
> > Thanks Boris to point out how to use git to commit correct authorship :-).
> >
> Hi, Thomas
> 
> Would you please help to merge this patch series into a proper tree?

Maybe Tony could pick those up?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
