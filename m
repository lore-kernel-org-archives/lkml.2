Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2FMJCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:02:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55764 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2FMJCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:02:33 -0400
Message-ID: <1339578142.31548.128.camel@twins>
Subject: Re: [PATCH V5 0/13] perf: Intel uncore pmu counting support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: Stephane Eranian <eranian@google.com>, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Date: Wed, 13 Jun 2012 11:02:22 +0200
In-Reply-To: <4FD7EFCB.6060005@intel.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBQu1hTa2R-PKsygLqOSSD9nu3+xR-79pT-8bB8Y16CBuw@mail.gmail.com>
	 <4FD7EFCB.6060005@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 09:41 +0800, Yan, Zheng wrote:
> Peter suggests keeping the uncore names as they're listed in the intel
> doc. For Sandybirdge-EP, uncore names are something like: Cbo, iMC,
> QPI. 

No they're not, they're C-Box etc.. but I'm fine with doing a tolower on
all of it.
