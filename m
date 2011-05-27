Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1E0SW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1E0SWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:22:25 -0400
Date: Fri, 27 May 2011 14:22:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: prasad@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        crash-utility@redhat.com, Andi Kleen <andi@firstfloor.org>,
        "Luck, Tony" <tony.luck@intel.com>, kexec@lists.infradead.org,
        anderson@redhat.com, Wang Chao <wang.chao@cn.fujitsu.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: Re: [RFC Patch 6/6] Crash: Recognise slim coredumps and process new
 elf-note sections
Message-ID: <20110527182210.GH8053@redhat.com>
References: <20110526170722.GB23266@in.ibm.com>
 <20110526172618.GB18295@in.ibm.com>
 <m11uzk80vx.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11uzk80vx.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:16:34AM -0700, Eric W. Biederman wrote:
> "K.Prasad" <prasad@linux.vnet.ibm.com> writes:
> 
> > Crash: Recognise slim coredumps and process new elf-note sections
> >
> > The Linux kernel will begin to support SlimDump for certain types of crashes
> > and the 'crash' tool needs to recognise them. For these types of coredumps, it
> > need not lookout for usual elf-structures and start gdb. Also process new
> > elf-note sections that contain additional information about the crash.
> 
> I suppose patching crash make sense.
> 
> Unfortunately crash doesn't work on  99% of the  kernels I run so, so I
> stopped caring a while ago.

Are these patched kernels? Otherwise Dave Anderson is pretty good about
keeping crash running across multiple kernels.

For me it works just great. I recently analyzed a crash dump with
2.6.39-rc7 kernel. Dave is generally takes patches for crash for latest
upstream kernel changes.

Thanks
Vivek
