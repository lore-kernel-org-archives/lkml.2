Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126Ab1EZS36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:29:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29456 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab1EZS35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:29:57 -0400
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        jrbarnette@chromium.org, Neil Brown <neilb@suse.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: dm: pass up rotational flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1306356648-30730-1-git-send-email-msb@chromium.org>
	<20110526182321.GA26219@redhat.com>
Date: Thu, 26 May 2011 14:29:41 -0400
In-Reply-To: <20110526182321.GA26219@redhat.com> (Mike Snitzer's message of
	"Thu, 26 May 2011 14:23:21 -0400")
Message-ID: <yq1zkm948oa.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DDE9C21.00C5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> Allow the NONROT flag to be passed through to linear mappings if all
>> underlying device are non-rotational. Tools like ureadahead will
>> schedule IOs differently based on the rotational flag.

Mike> Thanks for doing this, looks good in general.

I'd rather we made the rotational property part of the topology instead
of having to special-case it in DM. I seem to recall posting a patch
that did that at some point but I can't seem to find it...

-- 
Martin K. Petersen	Oracle Linux Engineering
