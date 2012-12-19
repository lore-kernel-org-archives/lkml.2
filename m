Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2LSUph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:45:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2LSUpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:45:30 -0500
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <50CB8C74.3090102@canonical.com>
	<yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com>
	<yq1bodq7zdv.fsf@sermon.lab.mkp.net>
	<20121219195801.GA14456@redhat.com>
Date: Wed, 19 Dec 2012 15:45:25 -0500
In-Reply-To: <20121219195801.GA14456@redhat.com> (Mike Snitzer's message of
	"Wed, 19 Dec 2012 14:58:01 -0500")
Message-ID: <yq14njh7ouy.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> But do we know mount to somwhow be issuing WRITE SAME requests?

I'm assuming that ext4 is somehow calling sb_issue_zeroout().


Mike> Martin, why is it you weren't able to reproduce (I haven't
Mike> attempted yet)?

Dunno.

But regardless of any bugs, WRITE SAME will still need some special
attention in the context of dm-crypt.

-- 
Martin K. Petersen	Oracle Linux Engineering
