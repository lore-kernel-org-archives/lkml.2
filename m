Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002Ab2JYJMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:12:53 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46775 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934834Ab2JYJMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:12:51 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-ca-50890292b576
From: Namhyung Kim <namhyung@kernel.org>
To: "Yan\, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH V2 7/7] perf, x86: Discard zero length call entries in LBR call stack
References: <1351058350-9159-1-git-send-email-zheng.z.yan@intel.com>
	<1351058350-9159-8-git-send-email-zheng.z.yan@intel.com>
Date: Thu, 25 Oct 2012 18:12:49 +0900
In-Reply-To: <1351058350-9159-8-git-send-email-zheng.z.yan@intel.com> (Zheng
	Yan's message of "Wed, 24 Oct 2012 13:59:10 +0800")
Message-ID: <87zk3a9apa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 24 Oct 2012 13:59:10 +0800, Zheng Yan wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Zero length calls may confuse the hardware and make the recorded
> call stack incorrect. Try fixing the call stack by discarding
> zero length call entries.

It would be great adding an explanation what is the "zero length call"
and why it makes a confusion.

Thanks,
Namhyung
