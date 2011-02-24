Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab1BXHGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:06:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46603 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab1BXHGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:06:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=uJx2VdHwIp/08FOdqAT+gm6m5EsFnbB0zstoBPqKNLMAcFaQteBWzdk9uNbk7fJK9q
         RSZKyDlmWFpd5rJjT4Aw==
Date: Wed, 23 Feb 2011 23:05:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Li Zefan <lizf@cn.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cpuset: Add a missing unlock in cpuset_write_resmask()
In-Reply-To: <4D6601B2.1090207@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1102232305360.5816@chino.kir.corp.google.com>
References: <4D6601B2.1090207@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Li Zefan wrote:

> Don't forget to release cgroup_mutex if alloc_trial_cpuset() fails.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
