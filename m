Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab2CMRT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:19:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18330 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab2CMRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:19:28 -0400
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Shaohua Li <shli@fusionio.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk
Subject: Re: [patch 6/7] blk: add plug for blkdev_issue_discard
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120312030412.375458948@fusionio.com>
	<20120312031305.946211513@fusionio.com>
	<20120313155120.GG29169@redhat.com>
	<yq1vcm8a0ud.fsf@sermon.lab.mkp.net>
	<20120313171414.GJ29169@redhat.com>
Date: Tue, 13 Mar 2012 13:19:15 -0400
In-Reply-To: <20120313171414.GJ29169@redhat.com> (Vivek Goyal's message of
	"Tue, 13 Mar 2012 13:14:14 -0400")
Message-ID: <yq1mx7ka06k.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A020209.4F5F8198.0089,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Vivek" == Vivek Goyal <vgoyal@redhat.com> writes:

Vivek> So first we will get rid of mering discard request 

We'll get rid of code that doesn't do anything other than confuse.


Vivek> and then enable after one release cycle once REQ_COPY support is
Vivek> in?

The new code will be entirely different. And one cycle is optimistic
given the current state of affairs in T10.

-- 
Martin K. Petersen	Oracle Linux Engineering
