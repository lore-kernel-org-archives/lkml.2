Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab2DPKVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 06:21:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:43717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2DPKVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 06:21:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="154091599"
Date: Mon, 16 Apr 2012 12:30:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 06/15] mfd: mark const init data with __initconst
 instead of __initdata
Message-ID: <20120416103023.GE1647@sortiz-mobl>
References: <20120330200358.GV15647@pengutronix.de>
 <1333137905-13809-6-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1333137905-13809-6-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Fri, Mar 30, 2012 at 10:04:56PM +0200, Uwe Kleine-König wrote:
> As long as there is no other non-const variable marked __initdata in the
> same compilation unit it doesn't hurt. If there were one however
> compilation would fail with
> 
> 	error: $variablename causes a section type conflict
> 
> because a section containing const variables is marked read only and so
> cannot contain non-const variables.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
