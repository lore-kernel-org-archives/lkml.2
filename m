Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab0DFVZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:25:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:39771 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691Ab0DFVZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:25:08 -0400
Message-ID: <4BBBA734.1000406@kernel.org>
Date: Wed, 07 Apr 2010 06:27:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, efault@gmx.de, fweisbec@gmail.com,
       Lee.Schermerhorn@hp.com, tj@kernel.org, tglx@linutronix.de,
       cl@linux-foundation.org, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf kmem: Fix breakage introduced by 5a0e3ad
 slab.h script
References: <1270561053-14308-1-git-send-email-acme@infradead.org> <tip-8c40041f75a202ed6a3b38143b823cb80f6d6b7c@git.kernel.org>
In-Reply-To: <tip-8c40041f75a202ed6a3b38143b823cb80f6d6b7c@git.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 21:23:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 12:51 AM, tip-bot for Arnaldo Carvalho de Melo wrote:
> Commit-ID:  8c40041f75a202ed6a3b38143b823cb80f6d6b7c
> Gitweb:     http://git.kernel.org/tip/8c40041f75a202ed6a3b38143b823cb80f6d6b7c
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Tue, 6 Apr 2010 10:37:33 -0300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 6 Apr 2010 17:48:06 +0200
> 
> perf kmem: Fix breakage introduced by 5a0e3ad slab.h script

Thanks.

-- 
tejun
