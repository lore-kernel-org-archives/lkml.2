Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab0ECGdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 02:33:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48484 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab0ECGdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 02:33:41 -0400
Message-ID: <4BDE6D5A.6060407@zytor.com>
Date: Sun, 02 May 2010 23:29:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
References: <1272841142-26029-1-git-send-email-acme@infradead.org> <20100503062407.GB15241@elte.hu>
In-Reply-To: <20100503062407.GB15241@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2010 11:24 PM, Ingo Molnar wrote:
> 
> Pulled, thanks a lot!
> 

With this, core/hweight should work properly, I hope.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

