Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992966Ab2KOItP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:49:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36777 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992537Ab2KOItN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:49:13 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50A4AC67.5000102@jp.fujitsu.com>
Date: Thu, 15 Nov 2012 17:48:39 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        x86@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 4/4] mm, oom: remove statically defined arch functions
 of same name
References: <alpine.DEB.2.00.1211140111190.32125@chino.kir.corp.google.com> <alpine.DEB.2.00.1211140113480.32125@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211140113480.32125@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/11/14 18:15), David Rientjes wrote:
> out_of_memory() is a globally defined function to call the oom killer.
> x86, sh, and powerpc all use a function of the same name within file
> scope in their respective fault.c unnecessarily.  Inline the functions
> into the pagefault handlers to clean the code up.
>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

I think this is good.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


