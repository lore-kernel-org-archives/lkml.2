Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845Ab2JXHAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:00:12 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49101 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933282Ab2JXHAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:00:10 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-e7-508791f8908b
From: Namhyung Kim <namhyung@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf header: Fix numa topology printing
References: <20121023072702.GB2772@turtle.usersys.redhat.com>
	<1350999890-6920-1-git-send-email-namhyung@kernel.org>
	<20121023141218.GD2772@turtle.usersys.redhat.com>
Date: Wed, 24 Oct 2012 16:00:08 +0900
In-Reply-To: <20121023141218.GD2772@turtle.usersys.redhat.com> (Andrew Jones's
	message of "Tue, 23 Oct 2012 16:12:19 +0200")
Message-ID: <874nlk9wxz.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, 23 Oct 2012 16:12:19 +0200, Andrew Jones wrote:
> On Tue, Oct 23, 2012 at 10:44:49PM +0900, Namhyung Kim wrote:
>> Andrew reported that the commit 7e94cfcc9d20 ("perf header: Use pre-
>> processed session env when printing") regresses the header output.
>> It was because of a missed string pointer calculation in the loop.
>
> works for me
>
> Tested-by: Andrew Jones <drjones@redhat.com> 

Did you test both of the patches?

Thanks,
Namhyung
