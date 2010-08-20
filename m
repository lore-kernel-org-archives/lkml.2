Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0HTKGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:06:44 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50743 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab0HTKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:06:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Rubin <mrubin@google.com>
Subject: Re: [PATCH 4/4] writeback: Reporting dirty thresholds in /proc/vmstat
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, npiggin@kernel.dk,
        hch@lst.de, axboe@kernel.dk
In-Reply-To: <1282296689-25618-5-git-send-email-mrubin@google.com>
References: <1282296689-25618-1-git-send-email-mrubin@google.com> <1282296689-25618-5-git-send-email-mrubin@google.com>
Message-Id: <20100820190603.6003.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 20 Aug 2010 19:06:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The kernel already exposes the user desired thresholds in /proc/sys/vm
> with dirty_background_ratio and background_ratio. But the kernel may
> alter the number requested without giving the user any indication that
> is the case.
> 
> Knowing the actual ratios the kernel is honoring can help app developers
> understand how their buffered IO will be sent to the disk.
> 
> 	$ grep threshold /proc/vmstat
> 	nr_dirty_threshold 409111
> 	nr_dirty_background_threshold 818223
> 
> Signed-off-by: Michael Rubin <mrubin@google.com>

Looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



