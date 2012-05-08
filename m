Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab2EHPKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:10:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60751 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2EHPKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:10:10 -0400
Message-ID: <1336489778.16236.50.camel@twins>
Subject: Re: [PATCH v3 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 17:09:38 +0200
In-Reply-To: <1336485790-30902-7-git-send-email-alex.shi@intel.com>
References: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
	 <1336485790-30902-7-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 22:03 +0800, Alex Shi wrote:
> This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start,
> end)
> in cases. 

Uhm, no please don't. That's called flush_tlb_range().
