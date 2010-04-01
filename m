Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab0DAUGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:06:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:7793 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799Ab0DAUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:06:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,350,1267430400"; 
   d="scan'208";a="609592005"
Subject: Re: BUG: null pointer deref in dmar_ir_support
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Jan.Grossmann@kielnet.net" <Jan.Grossmann@kielnet.net>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "mingo@elte.hu" <mingo@elte.hu>, "Han, Weidong" <weidong.han@intel.com>,
       "Song, Youquan" <youquan.song@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
In-Reply-To: <4BB4E400.5090602@kielnet.net>
References: <4BAD1676.9090704@kielnet.net>
	 <1270057394.2866.9.camel@sbs-t61.sc.intel.com>
	 <4BB395B0.6090007@kielnet.net>
	 <1270083887.7835.78.camel@sbs-t61.sc.intel.com>
	 <4BB4E400.5090602@kielnet.net>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 01 Apr 2010 13:04:40 -0700
Message-Id: <1270152280.2762.249.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 11:20 -0700, Jan.Grossmann@kielnet.net wrote:
> The patch seems to work,
> but now my kernel won't find any IDE, SATA or USB drives anymore and 
> then i end up with
> 
> Kernel panic - not syncing: VFS: Unable to mount root fs on 
> unknown-block(0,0)

hmm.. This sounds like a modules issue. Jan you were using modules in
your kernel config. You have initrd etc setup properly?

thanks,
suresh

