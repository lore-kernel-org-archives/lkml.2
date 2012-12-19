Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2LSUqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:46:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24279 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab2LSUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:45:52 -0500
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com, Milan Broz <mbroz@redhat.com>
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <50CB8C74.3090102@canonical.com>
	<yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com>
	<yq1bodq7zdv.fsf@sermon.lab.mkp.net>
	<20121219195801.GA14456@redhat.com> <50D21C93.5050907@canonical.com>
Date: Wed, 19 Dec 2012 15:45:48 -0500
In-Reply-To: <50D21C93.5050907@canonical.com> (Joseph Salisbury's message of
	"Wed, 19 Dec 2012 14:59:15 -0500")
Message-ID: <yq1zk196a9v.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joseph" == Joseph Salisbury <joseph.salisbury@canonical.com> writes:

Joseph> Martin, were you using the scsi_debug module, or a real scsi
Joseph> device(s)?

I used scsi_debug for the test.

-- 
Martin K. Petersen	Oracle Linux Engineering
