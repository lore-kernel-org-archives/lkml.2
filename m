Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab0GTW1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:27:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:45769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932870Ab0GTW1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:27:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="537316552"
Subject: Re: [PATCH 10/10] x86, xsave: make init_xstate_buf static
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-11-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-11-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 15:26:31 -0700
Message-Id: <1279664791.2899.55.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> The pointer is only used in xsave.c. Making it static.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

