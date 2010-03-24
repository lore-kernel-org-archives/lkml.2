Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab0CXRzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:55:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:31739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab0CXRzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,301,1267430400"; 
   d="scan'208";a="551776568"
Subject: Re: [PATCH 2/4] iwlwifi: don't include iwl-dev.h from
 iwl-devtrace.h
From: reinette chatre <reinette.chatre@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Lee.Schermerhorn@hp.com" <Lee.Schermerhorn@hp.com>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>, "Zhu, Yi" <yi.zhu@intel.com>,
       "ilw@linux.intel.com" <ilw@linux.intel.com>,
       Ingo Molnar <mingo@redhat.com>
In-Reply-To: <1269420538-18039-3-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
	 <1269420538-18039-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 10:55:50 -0700
Message-ID: <1269453350.2446.3151.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 01:48 -0700, Tejun Heo wrote:
> iwl-devtrace.h is used to declare and define trace points and
> including iwl-dev.h from the file, which in turn includes other
> generic headers can lead to problems like generating duplicate copies
> of generic trace points depending on the order of includes.  Don't
> include iwl-dev.h from iwl-devtrace.h but include it from its users -
> iwl-io.h and iwl-devtrace.c.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: Intel Linux Wireless <ilw@linux.intel.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---

Thank you

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


