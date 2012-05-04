Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760405Ab2EDW27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:28:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40692 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab2EDW25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:28:57 -0400
Message-ID: <4FA4581A.2030001@landley.net>
Date: Fri, 04 May 2012 17:28:42 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 5/7] Docs, cpusets: Update the cpuset documentation
References: <20120504191535.4603.83236.stgit@srivatsabhat> <20120504191938.4603.62771.stgit@srivatsabhat>
In-Reply-To: <20120504191938.4603.62771.stgit@srivatsabhat>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2012 02:19 PM, Srivatsa S. Bhat wrote:
> Add documentation for the newly introduced cpuset.actual_cpus file and
> describe the new semantics for updating cpusets upon CPU hotplug.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org

Yup, it looks like documentation:

Acked-by: Rob Landley <rob@landley.net>

> +then the cpuset hierarchy is traversed, searching for the nearest
> +ancestor whose cpu mask has atleast one online cpu. Then the tasks in

at least is two words.

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
