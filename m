Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2GQUx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 16:53:57 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35420 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab2GQUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 16:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <201207172252.06093.rjw@sisk.pl>
References: <201207162246.03660.rjw@sisk.pl>
	<87mx2zcq62.fsf@ti.com>
	<201207172252.06093.rjw@sisk.pl>
Date: Tue, 17 Jul 2012 13:53:52 -0700
X-Google-Sender-Auth: ELLekavOjL4x9Cskt493u6pwfJ4
Message-ID: <CAMbhsRQHMu-zzkhJxYLvszQ2+=OVEJwKrCTbGCjpYGtnP-tttg@mail.gmail.com>
Subject: Re: PM: Summary of changes for v3.6
From: Colin Cross <ccross@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 1:52 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>
> On Tuesday, July 17, 2012, Kevin Hilman wrote:
>> Rafael, Daniel,
>>
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>
>> > Hi all,
>> >
>> > All of the changes I'd like to include into the first PM pull request during
>> > the v3.6 merge window, except maybe for one or two patches I know are in the
>> > works, is on the 'linux-next' branch of the linux-pm.git tree now.  The summary
>> > of those changes is appended.  If anyone finds any of them objectionable,
>> > please let me know ASAP.  Also please let me know if you have any power
>> > management patches you'd like me to take for v3.6.
>> >
>>
>> Could someone please clarify the status of the coupled CPUidle series?
>>
>> There's a version of these in Daniels cpuidle-next branch and there's a
>> version of these in Len's next branch (included in linux-next), but I'm
>> still not entirely sure which branch is going upstream and which branch
>> has the latest version (but I think Daniel's is the latest)
>
> Colin says that the commits in the Len's tree match his latest version,
> so I think those commits should be merged, since they have been present
> in that tree since the 3.5 merge window.

The disappeared from Len's tree for a little while after the 3.5 merge
window, which is why they started appearing other places.  Now that
they have returned to Len's tree, hopefully to stay, they should be
considered the official version.
