Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab2IJBmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 21:42:37 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53513 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905Ab2IJBmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 21:42:36 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-69-504d45899736
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] perf ui/browser: Add browser for perf script
References: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
Date: Mon, 10 Sep 2012 10:35:32 +0900
In-Reply-To: <1347007349-3102-1-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Fri, 7 Sep 2012 16:42:22 +0800")
Message-ID: <87ehmabqxn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng,

On Fri,  7 Sep 2012 16:42:22 +0800, Feng Tang wrote:
> Hi Arnaldo and all,
>
> This is a patch set mainly to add a browser for perf script, which
> will be integrated into the main hists and annotation browser.
>
> Patch 1-4 are some preparation for adding the script
> patch 5 introduce the script browser
> patch 6-7 integrate the browser to hists browser and annotation browser
>
> The patches are on top of current perf/core branch of your git tree. 
> Please help to review. 
>
> Namhyung,
>
> Many thanks for providing many good comments for the v1 patch sets. In
> this v2, I addressed most of those comments, for the suggestion to use
> browser for "perf script -l", I'll handle it later, and would post the
> v2 first for review.
>
> Changelog:
> 	Since v1:
> 	* Add filter for scripts can't be run in script browser
> 	* Fix some bugs about buffer handling and error check 

For whole series,

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks for your work!
Namhyung
