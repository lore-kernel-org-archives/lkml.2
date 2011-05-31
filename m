Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab1EaCWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 22:22:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38083 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab1EaCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 22:22:51 -0400
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jaxboe@fusionio.com,
        msb@chromium.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 3/3] block: Move discard and secure discard flags to queue limits
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4DDEA689.2090004@fusionio.com>
	<1306464169-4291-1-git-send-email-martin.petersen@oracle.com>
	<1306464169-4291-4-git-send-email-martin.petersen@oracle.com>
	<20110527133952.GC17219@redhat.com>
Date: Mon, 30 May 2011 22:22:37 -0400
In-Reply-To: <20110527133952.GC17219@redhat.com> (Mike Snitzer's message of
	"Fri, 27 May 2011 09:39:52 -0400")
Message-ID: <yq1fwnvzk0i.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4DE450F9.0001:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Most targets do support discards (tgt->num_discard_requests > 0).
Mike> But if any target doesn't support discards then the entire table
Mike> doesn't support them.

Would you rather have the stacking policy for discard be | instead of &?

-- 
Martin K. Petersen	Oracle Linux Engineering
