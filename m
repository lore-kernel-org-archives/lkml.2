Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0CaPSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab0CaPSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:18:35 -0400
Date: Wed, 31 Mar 2010 11:16:20 -0400
From: Dave Jones <davej@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, trenn@suse.de,
       linux@dominikbrodowski.net, mingo@elte.hu, tglx@linutronix.de,
       cpufreq@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [-v2 PATCH 2/6] powernow-k8: Add core performance boost support
Message-ID: <20100331151620.GA1893@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, trenn@suse.de,
	linux@dominikbrodowski.net, mingo@elte.hu, tglx@linutronix.de,
	cpufreq@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1269610800-23847-1-git-send-email-bp@amd64.org>
 <1269610800-23847-3-git-send-email-bp@amd64.org>
 <20100330154229.dc8ebd24.akpm@linux-foundation.org>
 <20100331061343.GA28659@aftab>
 <20100330232221.826fe933.akpm@linux-foundation.org>
 <20100331063546.GB28659@aftab>
 <20100330233851.17370621.akpm@linux-foundation.org>
 <4BB2EEE1.4010904@zytor.com>
 <20100331150854.GC30028@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331150854.GC30028@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 05:08:54PM +0200, Borislav Petkov wrote:
 > From: "H. Peter Anvin" <hpa@zytor.com>
 > Date: Tue, Mar 30, 2010 at 11:42:41PM -0700
 > 
 > > On 03/30/2010 08:38 PM, Andrew Morton wrote:
 > > > 
 > > > I've unilaterally decided that all six patches should be merged via the
 > > > x86 tree, btw.  They could be split between x86 and cpufreq, but I
 > > > suspect there are interdependencies which would make that hard.
 > > > 
 > > 
 > > I would agree with that.  I'll try to get them in tomorrow.
 > 
 > Cool. I'll have updated versions of the patches soon - just don't take
 > those yet.

fine, I'll drop these from the cpufreq git tree later.

	Dave

