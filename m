Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2HMNWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:22:32 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39155 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2HMNWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:22:31 -0400
Date: Mon, 13 Aug 2012 18:51:49 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] uprobes: do not use -EEXIST in
 install_breakpoint()	paths
Message-ID: <20120813132149.GI31805@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120808173659.GA13220@redhat.com>
 <20120808173744.GA13269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120808173744.GA13269@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12081313-4790-0000-0000-0000041C7E35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:44]:

> -EEXIST from install_breakpoint() no longer makes sense, all
> callers should simply treat it as "success". Change the code
> to return zero and simplify register_for_each_vma().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

