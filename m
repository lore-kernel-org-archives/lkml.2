Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab1HVPD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:03:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:63719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab1HVPDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:03:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,263,1312182000"; 
   d="scan'208";a="42742381"
Date: Mon, 22 Aug 2011 17:05:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: rjw@sisk.pl, menage@google.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, oleg@redhat.com, Marcel Holtmann <marcel@holtmann.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        wwang <wei_wang@realsil.com.cn>
Subject: Re: [PATCH 02/16] freezer: don't unnecessarily set PF_NOFREEZE
 explicitly
Message-ID: <20110822150523.GZ4607@sortiz-mobl>
References: <1313763382-12341-1-git-send-email-tj@kernel.org>
 <1313763382-12341-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313763382-12341-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Fri, Aug 19, 2011 at 04:16:08PM +0200, Tejun Heo wrote:
> Some drivers set PF_NOFREEZE in their kthread functions which is
> completely unnecessary and racy - some part of freezer code doesn't
> consider cases where PF_NOFREEZE is set asynchronous to freezer
> operations.
> 
> In general, there's no reason to allow setting PF_NOFREEZE explicitly.
> Remove them and change the documentation to note that setting
> PF_NOFREEZE directly isn't allowed.

For the mfd parts:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
