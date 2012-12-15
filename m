Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2LOClU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 21:41:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2LOClT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 21:41:19 -0500
Message-ID: <50CBE329.7070005@canonical.com>
Date: Fri, 14 Dec 2012 21:40:41 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Kernel Team <kernel-team@lists.ubuntu.com>, linux-kernel@vger.kernel.org,
        snitzer@redhat.com, jgarzik@redhat.com, JBottomley@Parallels.com
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
References: <50CB8C74.3090102@canonical.com> <yq11uesdzya.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq11uesdzya.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 05:35 PM, Martin K. Petersen wrote:
>>>>>> "Joseph" == Joseph Salisbury <joseph.salisbury@canonical.com> writes:
> Joseph> I see that you are the author of this patch, so I wanted to run
> Joseph> this by you.  I was thinking of requesting a revert for v3.7,
> Joseph> but I wanted to get your feedback first.
>
> I copied luksformat from a Debian box so I could try to reproduce on
> OL6. Everything works fine for me here. I set up a encrypted ext4
> device, unpacked a kernel tarball, and did a build.
>
> The oops screenshot in the launchpad bug report is pretty useless.
> Please provide a full backtrace so we can get a better idea what's going
> on.
>

Thanks for the feedback, Martin.

I will do some additional research and testing.  I'll be sure to capture 
a full backtrace for analysis.

Thanks again,

Joe
