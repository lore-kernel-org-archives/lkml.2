Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab2EOKdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:33:25 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:50145 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2EOKdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:33:24 -0400
Date: Tue, 15 May 2012 12:33:07 +0200
From: Borislav Petkov <bp@amd64.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org,
        fweisbec@gmail.com, jeremy@goop.org, gregkh@linuxfoundation.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one in
 flush_tlb_range
Message-ID: <20120515103307.GB27153@aftab.osrc.amd.com>
References: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
 <1336626013-28413-4-git-send-email-alex.shi@intel.com>
 <20120510084213.GD30055@aftab.osrc.amd.com>
 <4FAB84B6.7060706@intel.com>
 <4FAE18D0.6050001@intel.com>
 <20120513111328.GD28863@aftab.osrc.amd.com>
 <4FB1AC03.2070407@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1AC03.2070407@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 09:06:11AM +0800, Alex Shi wrote:
> Thanks for your input. but actually, total 3 labels doesn't looks
> good. Maybe the following lines can meet your expectation.

Yeah, a bit better.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
