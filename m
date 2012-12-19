Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2LSQ6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:58:20 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23894 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2LSQ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:58:11 -0500
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kernel Team <kernel-team@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, snitzer@redhat.com, jgarzik@redhat.com,
        JBottomley@Parallels.com
Subject: Re: [v3.7 Regression]  [SCSI] sd: Implement support for WRITE SAME
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <50CB8C74.3090102@canonical.com>
	<yq11uesdzya.fsf@sermon.lab.mkp.net> <50D0C971.1000907@canonical.com>
Date: Wed, 19 Dec 2012 11:58:04 -0500
In-Reply-To: <50D0C971.1000907@canonical.com> (Joseph Salisbury's message of
	"Tue, 18 Dec 2012 14:52:17 -0500")
Message-ID: <yq1bodq7zdv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Joseph" == Joseph Salisbury <joseph.salisbury@canonical.com> writes:

Joseph> I captured the netconsole output from boot until I reproduced
Joseph> the bug. The RIP points to kcryptd_crypt_write_io_submit() in
Joseph> ~/drivers/md/dm-crypt.c.  The output can be seen at:

I'm thinking that dm-crypt should probably set max_write_same_sectors to
0. It doesn't really make much sense for a crypto driver to pass that
command through.

Mike, do you want to look into this?

-- 
Martin K. Petersen	Oracle Linux Engineering
