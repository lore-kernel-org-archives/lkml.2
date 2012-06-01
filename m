Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab2FACEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 22:04:00 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:37672 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab2FACD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 22:03:58 -0400
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <201205211518.39137.rjw@sisk.pl> <882dce83-b79e-4470-af25-edb8429fb7e5@email.android.com> <201205212353.42639.rjw@sisk.pl> <1337637359.1647.67.camel@shrek.rexursive.com> <20120524145122.GA26743@x1.osrc.amd.com> <07f1a575-ec44-40b7-bd36-576f883f188d@email.android.com> <20120531162342.GA3541@x1.osrc.amd.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120531162342.GA3541@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
Date: Fri, 01 Jun 2012 12:03:47 +1000
To: Borislav Petkov <bp@alien8.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Message-ID: <91027f5c-239f-4b91-b6b4-2fcac6e1bcb7@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:

>On Fri, May 25, 2012 at 12:02:15PM +1000, Bojan Smojver wrote:
>> Sorry. That patch is here (pretty much the original with signed-off):
>> 
>> http://marc.info/?l=linux-kernel&m=133651588229850&w=2
>
>Ok, I finally gave the above a run, here's the dmesg after a successful
>suspend-resume cycle. It looks ok except the funny characters after
>
>"[  380.938864] PM: Compressing and saving image data (75689 pages)
>..."
>
>I'll keep running it the next couple of days/weeks and report any
>instabilities.


Thanks for testing. The funny characters are backspaces printed by the progress indicator. :-)

-- 
Bojan
