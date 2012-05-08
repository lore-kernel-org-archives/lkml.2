Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490Ab2EHQK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:10:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53144 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab2EHQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:10:27 -0400
Date: Tue, 8 May 2012 09:10:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Alex Shi <alex.shi@intel.com>, mgorman@suse.de, npiggin@gmail.com,
        tglx@linutronix.de, mingo@redhat.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        glommer@redhat.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for
 user change
Message-ID: <20120508161022.GC20433@kroah.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
 <1336485790-30902-8-git-send-email-alex.shi@intel.com>
 <1336489894.16236.51.camel@twins>
 <4FA939B9.6000404@zytor.com>
 <20120508152516.GF13568@aftab.osrc.amd.com>
 <4FA93C69.3050905@zytor.com>
 <20120508154150.GG13568@aftab.osrc.amd.com>
 <4FA94051.3000307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA94051.3000307@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 08:48:33AM -0700, H. Peter Anvin wrote:
> On 05/08/2012 08:41 AM, Borislav Petkov wrote:
> > On Tue, May 08, 2012 at 08:31:53AM -0700, H. Peter Anvin wrote:
> >> On 05/08/2012 08:25 AM, Borislav Petkov wrote:
> >>>
> >>> Yep, this was supposed to be for pinpointing the proper entries count.
> >>> I believe we don't have this thing of having code intree but not really
> >>> intree - only for testing new silicon. Maybe a debug module or add this
> >>> to debugfs?
> >>>
> >>
> >> We have a lot of that kind of code, it is usually hidden under
> >> CONFIG_*DEBUG* something.
> > 
> > Then maybe this is where this knob should go, along with adding it to
> > debugfs instead of sysfs...
> > 
> 
> I don't see a problem with it in sysfs.

If it's in sysfs, it better be documented in Documentation/ABI.

