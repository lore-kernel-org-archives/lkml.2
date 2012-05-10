Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2EJJhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:37:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52288 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2EJJhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:37:46 -0400
Message-ID: <1336642648.2527.83.camel@twins>
Subject: Re: [PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific
 CPU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alex Shi <alex.shi@intel.com>
Cc: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 11:37:28 +0200
In-Reply-To: <1336626013-28413-6-git-send-email-alex.shi@intel.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
	 <1336626013-28413-6-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 13:00 +0800, Alex Shi wrote:
> +       case 0x62a: /* SandyBridge */
> +       case 0x62d: /* SandyBridge, "Romely-EP" */
> +               tlb_flushall_factor = 5;
> +               break;

One would expect some IVB stuff here.. surely you have some.

> +       default:
> +               tlb_flushall_factor = 6;
> +       } 


