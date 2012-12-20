Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab2LTALd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:11:33 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33510 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab2LTALZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:11:25 -0500
To: Milan Broz <mbroz@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, jgarzik@redhat.com,
        JBottomley@Parallels.com
Subject: Re: [PATCH] dm-crypt: never use write same (was Re: [v3.7 Regression] [SCSI] sd: Implement support for WRITE SAME)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <50CB8C74.3090102@canonical.com>
	<yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com>
	<yq1bodq7zdv.fsf@sermon.lab.mkp.net>
	<20121219195801.GA14456@redhat.com> <50D22766.9090107@redhat.com>
	<50D22C7F.2020201@redhat.com>
Date: Wed, 19 Dec 2012 19:11:13 -0500
In-Reply-To: <50D22C7F.2020201@redhat.com> (Milan Broz's message of "Wed, 19
	Dec 2012 22:07:11 +0100")
Message-ID: <yq1mwx960ri.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Milan" == Milan Broz <mbroz@redhat.com> writes:

Milan> dm-crypt: never use write same

Milan> Ciphertext device is not compatible with WRITE SAME, disable it
Milan> for all dmcrypt devices.

Milan> Signed-off-by: Milan Broz <mbroz@redhat.com>

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
