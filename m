Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2GSEs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 00:48:59 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63582 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2GSEsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 00:48:55 -0400
Message-ID: <500791B2.9010601@kernel.org>
Date: Thu, 19 Jul 2012 00:48:50 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PM: Summary of changes for v3.6
References: <201207162246.03660.rjw@sisk.pl> <87mx2zcq62.fsf@ti.com> <201207172252.06093.rjw@sisk.pl> <CAMbhsRQHMu-zzkhJxYLvszQ2+=OVEJwKrCTbGCjpYGtnP-tttg@mail.gmail.com>
In-Reply-To: <CAMbhsRQHMu-zzkhJxYLvszQ2+=OVEJwKrCTbGCjpYGtnP-tttg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The disappeared from Len's tree for a little while after the 3.5 merge
> window, which is why they started appearing other places.  Now that
> they have returned to Len's tree, hopefully to stay, they should be
> considered the official version.

Yes, they are staged for 3.6 in my tree.

The intent was to push them for 3.5, but some unrelated patches
exploded and stopped that push.  I then had to re-merge my tree
to push only the bug-fixes to 3.5, which is why the feature
patches went away for a bit.

thanks,
-Len



