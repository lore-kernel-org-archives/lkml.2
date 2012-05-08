Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2EHQ2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:28:23 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45318 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2EHQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:28:22 -0400
Date: Tue, 8 May 2012 18:28:09 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user change
Message-ID: <20120508162809.GL13568@aftab.osrc.amd.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
 <1336485790-30902-8-git-send-email-alex.shi@intel.com>
 <1336489894.16236.51.camel@twins>
 <4FA939B9.6000404@zytor.com>
 <20120508152516.GF13568@aftab.osrc.amd.com>
 <4FA93C69.3050905@zytor.com>
 <20120508154150.GG13568@aftab.osrc.amd.com>
 <4FA94051.3000307@zytor.com>
 <20120508161022.GC20433@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120508161022.GC20433@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 09:10:22AM -0700, Greg KH wrote:
> > > Then maybe this is where this knob should go, along with adding it to
> > > debugfs instead of sysfs...
> > 
> > I don't see a problem with it in sysfs.
> 
> If it's in sysfs, it better be documented in Documentation/ABI.

See what I'm sayin'? And besides, debugfs fits better the purpose of
this, maybe somewhere under <debugfs>/x86/...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
