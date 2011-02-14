Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1BNN2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:28:45 -0500
Received: from www.tglx.de ([62.245.132.106]:59007 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab1BNN2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:28:43 -0500
Date: Mon, 14 Feb 2011 14:27:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kirill A. Shutsemov" <kirill@shutemov.name>
cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 1/3] cgroups: export cgroup_iter_{start,next,end}
In-Reply-To: <1297688787-3592-2-git-send-email-kirill@shutemov.name>
Message-ID: <alpine.LFD.2.00.1102141421500.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-2-git-send-email-kirill@shutemov.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lacks any sensible explanation why and whatfor this needs to be
exported. And I really doubt that we want to export that at all.

> +EXPORT_SYMBOL_GPL(cgroup_iter_start);
> +EXPORT_SYMBOL_GPL(cgroup_iter_next);
> +EXPORT_SYMBOL_GPL(cgroup_iter_end);

Thanks,

	tglx
