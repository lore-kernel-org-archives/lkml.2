Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab1CGXFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:05:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345Ab1CGXFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:05:46 -0500
Date: Mon, 7 Mar 2011 15:05:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/04 v2] sysctl: change to use proc_dointvec_bool while
 needed
Message-Id: <20110307150526.9afedd47.akpm@linux-foundation.org>
In-Reply-To: <20110304154631.GB14672@darkstar>
References: <20110304154631.GB14672@darkstar>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 23:46:31 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> @@ -374,9 +372,7 @@ static struct ctl_table kern_table[] = {
>  		.data		= &sysctl_sched_autogroup_enabled,
>  		.maxlen		= sizeof(unsigned int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec,
> -		.extra1		= &zero,
> -		.extra2		= &one,
> +		.proc_handler	= proc_dointvec_bool,
>  	},

This field has changed in linux-next, so I dropped this hunk.
