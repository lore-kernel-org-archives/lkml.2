Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392Ab1EZSsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:48:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46956 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab1EZSso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:48:44 -0400
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        jrbarnette@chromium.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>, Alasdair G Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: Re: dm: pass up rotational flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1306356648-30730-1-git-send-email-msb@chromium.org>
	<20110526182321.GA26219@redhat.com>
	<yq1zkm948oa.fsf@sermon.lab.mkp.net>
	<20110526184321.GC26219@redhat.com>
Date: Thu, 26 May 2011 14:48:23 -0400
In-Reply-To: <20110526184321.GC26219@redhat.com> (Mike Snitzer's message of
	"Thu, 26 May 2011 14:43:21 -0400")
Message-ID: <yq1vcwx47t4.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DDEA082.00E9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Similarly, couldn't the discard flag be made part of topology?

Actually, now that I think about it I'm fairly sure my patch nuked the
discard queue flag because I was tired of keeping the flag and the
topology in sync. I don't think I mucked with the rotational flag.

Let me grep my patch queue and see. It must be in there somewhere...

-- 
Martin K. Petersen	Oracle Linux Engineering
