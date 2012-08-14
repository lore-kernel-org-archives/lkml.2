Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2HNFPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:15:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:60371 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab2HNFPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:15:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,764,1336374000"; 
   d="scan'208";a="200366423"
Date: Tue, 14 Aug 2012 13:15:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: gerg@snapgear.com
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, ebiederm@xmission.com,
        Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH] m68k: select CONFIG_GENERIC_ATOMIC64 for all m68k CPU
 types
Message-ID: <20120814051507.GA10244@localhost>
References: <1344919533-9357-1-git-send-email-gerg@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344919533-9357-1-git-send-email-gerg@snapgear.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 02:45:33PM +1000, gerg@snapgear.com wrote:
> From: Greg Ungerer <gerg@uclinux.org>
> 
> There is no specific atomic64 support code for any m68k CPUs, so we should
> select CONFIG_GENERIC_ATOMC64 for all. Remove the existing per CPU selection
> of this and select it for all m68k.
>
> Signed-off-by: Greg Ungerer <gerg@uclinux.org>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Thanks for the complete solution!
