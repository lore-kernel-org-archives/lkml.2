Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0ETVBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:01:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:50704 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0ETVA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:00:59 -0400
From: Thomas Renninger <trenn@suse.de>
To: Mike Chan <mike@android.com>
Subject: Re: [PATCH v2 0/3] Enable CPU frequency and power tracking in cpuacct cgroup
Date: Thu, 20 May 2010 23:01:11 +0200
User-Agent: KMail/1.9.10
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, khilman@deeprootsystems.com,
       linux-omap@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <1274380944-20947-1-git-send-email-mike@android.com>
In-Reply-To: <1274380944-20947-1-git-send-email-mike@android.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005202301.12259.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thursday 20 May 2010 08:42:21 pm Mike Chan wrote:
> v2:
> Rebased off of Thomas Renninger's patch for cgroups_cpuacct refactoring,
thanks.
A general comment:
I don't know much about the cgroup stuff.
I am also not sure how exactly power can be measured on this arch based on
frequency accounting (there also were some threads I was not aware of?)
A signed-off-by or reviewed-by from someone who is more involved in this omap
stuff would probably not that bad.

Still I Iike this interface and I could imagine others hook into it as well, 
for whatever has to be cpu cgroup accounted.

My two cents...,

     Thomas
