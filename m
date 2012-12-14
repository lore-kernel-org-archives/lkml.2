Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab2LNWgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:36:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16712 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab2LNWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:35:56 -0500
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: martin.petersen@oracle.com, Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, snitzer@redhat.com, jgarzik@redhat.com,
        JBottomley@Parallels.com
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <50CB8C74.3090102@canonical.com>
Date: Fri, 14 Dec 2012 17:35:41 -0500
In-Reply-To: <50CB8C74.3090102@canonical.com> (Joseph Salisbury's message of
	"Fri, 14 Dec 2012 15:30:44 -0500")
Message-ID: <yq11uesdzya.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joseph" == Joseph Salisbury <joseph.salisbury@canonical.com> writes:

Joseph> I see that you are the author of this patch, so I wanted to run
Joseph> this by you.  I was thinking of requesting a revert for v3.7,
Joseph> but I wanted to get your feedback first.

I copied luksformat from a Debian box so I could try to reproduce on
OL6. Everything works fine for me here. I set up a encrypted ext4
device, unpacked a kernel tarball, and did a build.

The oops screenshot in the launchpad bug report is pretty useless.
Please provide a full backtrace so we can get a better idea what's going
on.

-- 
Martin K. Petersen	Oracle Linux Engineering
