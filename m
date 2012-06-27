Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2F0Ch2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:37:28 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53241 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab2F0Ch1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:37:27 -0400
X-AuditID: 9c930179-b7befae000006417-13-4fea71dd54e9
Message-ID: <4FEA71E5.5090808@kernel.org>
Date: Wed, 27 Jun 2012 11:37:25 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.drivers.driver-project.devel,gmane.linux.kernel,gmane.linux.kernel.mm
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 1/3] zram/zcache: swtich Kconfig dependency from X86 to
 ZSMALLOC
References: <1340640878-27536-1-git-send-email-sjenning@linux.vnet.ibm.com> <1340640878-27536-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1340640878-27536-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 01:14 AM, Seth Jennings wrote:

> This patch switches zcache and zram dependency to ZSMALLOC
> rather than X86.  There is no net change since ZSMALLOC
> depends on X86, however, this prevent further changes to
> these files as zsmalloc dependencies change.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Reviewed-by: Minchan Kim <minchan@kernel.org>

It could be merged regardless of other patches in this series.

-- 
Kind regards,
Minchan Kim
