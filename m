Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab1K2R7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:59:18 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35226 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1K2R7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:59:17 -0500
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shuichi Ihara <sihara@ddn.com>
Subject: Re: [RFC PATCH] block: change max_segments default to USHRT_MAX
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1322517615-28530-1-git-send-email-snitzer@redhat.com>
Date: Tue, 29 Nov 2011 12:59:01 -0500
In-Reply-To: <1322517615-28530-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Mon, 28 Nov 2011 17:00:15 -0500")
Message-ID: <yq1mxbehkt6.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4ED51D71.008C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> The reported problem was that a DM multipath device's max_segemnts
Mike> was constrained to BLK_MAX_SEGMENTS (128) even though the
Mike> underlying paths' max_segments were larger.  For example, SCSI
Mike> establishes a max_segments of SCSI_MAX_SG_CHAIN_SEGMENTS (2048).

I'd rather that we revisited the patches I posted a while back where we
have different defaults for LLDs and stacking drivers.

I'll freshen those up and post them later today. I have a few concalls
to clear first...

-- 
Martin K. Petersen	Oracle Linux Engineering
