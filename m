Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2EXPGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 11:06:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53822 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab2EXPGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 11:06:21 -0400
Message-ID: <4FBE4E05.7070603@zytor.com>
Date: Thu, 24 May 2012 08:04:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Beulich <JBeulich@suse.com>,
        borislav.petkov@amd.com, arnd@arndb.de, akinobu.mita@gmail.com,
        eric.dumazet@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        hughd@google.com, jeremy@goop.org, len.brown@intel.com,
        tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>  <1337782555-8088-9-git-send-email-alex.shi@intel.com>  <4FBD18D20200007800085951@nat28.tlf.novell.com> <1337792984.9783.37.camel@laptop> <4FBDF200.7060608@intel.com>
In-Reply-To: <4FBDF200.7060608@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 01:32 AM, Alex Shi wrote:
> 
> Sure. but just want to know how many commercial x86 CPU uses >2 SMTs?
> Write a short, quick function to do random selection in SMT is quite
> complicate considering cpumask maybe just contain random number SMT
> siblings in a core.
> 

Wrong question.  This is a forward compatibility issue.  You have to
take into account potential future CPUs as well.

And no, it isn't hard.

	-hpa

