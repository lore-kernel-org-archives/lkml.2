Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab2ANUpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:45:38 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44670 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099Ab2ANUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1201141121300.7598-100000@netrider.rowland.org>
References: <20120114144938.GA32033@suse.de>
	<Pine.LNX.4.44L0.1201141121300.7598-100000@netrider.rowland.org>
Date: Sun, 15 Jan 2012 04:45:36 +0800
Message-ID: <CAAJw_Zuof_VEHS2MEq8dVe5LSSmFPzvRgCXLaFnfhiakA=0RFA@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 12:30 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 14 Jan 2012, Greg KH wrote:
>
>> On Fri, Jan 13, 2012 at 06:53:04PM -0800, Linus Torvalds wrote:
>> > On Fri, Jan 13, 2012 at 6:41 PM, Srivatsa S. Bhat
>> > <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> > >
>> > > YES!! Finally I have a fix for this whole MCE thing! :-)

Yeh! This fixed Suspend/Resume fixed too (re Linux-3.2.0 Pid: 1902,
comm: modprobe Not tainted 3.2.0 #64).

Now, I'm onto another issue with bluetooth. Bluetooth works well with
3.0.17 (may be 3.1.xx), but latest git is freezing the whole system
during pairing. Not good. Not sure whether this is related to the MCE.


Jeff.
