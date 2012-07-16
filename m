Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2GPWK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:10:58 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:47170 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab2GPWKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:10:54 -0400
From: Kevin Hilman <khilman@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PM: Summary of changes for v3.6
Organization: Texas Instruments, Inc.
References: <201207162246.03660.rjw@sisk.pl>
Date: Mon, 16 Jul 2012 15:11:17 -0700
In-Reply-To: <201207162246.03660.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 16 Jul 2012 22:46:03 +0200")
Message-ID: <87mx2zcq62.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael, Daniel,

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Hi all,
>
> All of the changes I'd like to include into the first PM pull request during
> the v3.6 merge window, except maybe for one or two patches I know are in the
> works, is on the 'linux-next' branch of the linux-pm.git tree now.  The summary
> of those changes is appended.  If anyone finds any of them objectionable,
> please let me know ASAP.  Also please let me know if you have any power
> management patches you'd like me to take for v3.6.
>

Could someone please clarify the status of the coupled CPUidle series?  

There's a version of these in Daniels cpuidle-next branch and there's a
version of these in Len's next branch (included in linux-next), but I'm
still not entirely sure which branch is going upstream and which branch
has the latest version (but I think Daniel's is the latest)

Thanks for clarifying,

Kevin

