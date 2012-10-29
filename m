Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2J2KIJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 06:08:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42732 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2J2KIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 06:08:07 -0400
X-AuditID: 9c930179-b7c8bae000003559-71-508e55843d59
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jolsa@redhat.com, eranian@google.com, mingo@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/33] perf, x86: Add PEBSv2 record support
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org>
	<1351283415-13170-2-git-send-email-andi@firstfloor.org>
Date: Mon, 29 Oct 2012 19:08:04 +0900
In-Reply-To: <1351283415-13170-2-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 26 Oct 2012 13:29:43 -0700")
Message-ID: <874nld8ubf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Fri, 26 Oct 2012 13:29:43 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Add support for the v2 PEBS format. It has a superset of the v1 PEBS
> fields, but has a longer record so we need to adjust the code paths.
>
> The main advantage is the new "EventingRip" support which directly
> gives the instruction, not off-by-one instruction. So with precise == 2
> we use that directly and don't try to use LBRs and walking basic blocks.
> This lowers the overhead significantly.

That means it can support precise == 3?

Thanks,
Namhyung

