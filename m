Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GZASI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 20:18:08 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:50098 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322Ab2GZASG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 20:18:06 -0400
From: Kevin Hilman <khilman@ti.com>
To: Len Brown <lenb@kernel.org>
Cc: Colin Cross <ccross@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PM: Summary of changes for v3.6
Organization: Texas Instruments, Inc.
References: <201207162246.03660.rjw@sisk.pl> <87mx2zcq62.fsf@ti.com>
	<201207172252.06093.rjw@sisk.pl>
	<CAMbhsRQHMu-zzkhJxYLvszQ2+=OVEJwKrCTbGCjpYGtnP-tttg@mail.gmail.com>
	<500791B2.9010601@kernel.org>
Date: Wed, 25 Jul 2012 17:18:02 -0700
In-Reply-To: <500791B2.9010601@kernel.org> (Len Brown's message of "Thu, 19
	Jul 2012 00:48:50 -0400")
Message-ID: <87a9yn74ud.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

>> The disappeared from Len's tree for a little while after the 3.5 merge
>> window, which is why they started appearing other places.  Now that
>> they have returned to Len's tree, hopefully to stay, they should be
>> considered the official version.
>
> Yes, they are staged for 3.6 in my tree.
>
> The intent was to push them for 3.5, but some unrelated patches
> exploded and stopped that push.  I then had to re-merge my tree
> to push only the bug-fixes to 3.5, which is why the feature
> patches went away for a bit.

Great, thanks for clarifying.

Kevin
