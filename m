Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0E0HjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 03:39:21 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46398 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab0E0HjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 03:39:19 -0400
Message-ID: <4BFE2204.3020502@cs.wisc.edu>
Date: Thu, 27 May 2010 02:40:52 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Rakesh Ranjan <rakesh@chelsio.com>, NETDEVML <netdev@vger.kernel.org>,
       SCSIDEVML <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Karen Xie <kxie@chelsio.com>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Anish Bhatt <anish@chelsio.com>, Rakesh Ranjan <rranjan@chelsio.com>
Subject: Re: [PATCH 2/3] cxgb4i_v3: main driver files
References: <1273944249-311-1-git-send-email-rakesh@chelsio.com> <1273944249-311-2-git-send-email-rakesh@chelsio.com> <1273944249-311-3-git-send-email-rakesh@chelsio.com> <4BFE2173.4050306@cs.wisc.edu>
In-Reply-To: <4BFE2173.4050306@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 02:38 AM, Mike Christie wrote:
> On 05/15/2010 12:24 PM, Rakesh Ranjan wrote:
>> From: Rakesh Ranjan<rranjan@chelsio.com>
>>
>>
>> Signed-off-by: Rakesh Ranjan<rakesh@chelsio.com>
>> ---
>> drivers/scsi/cxgb4i/cxgb4i.h | 101 ++
>> drivers/scsi/cxgb4i/cxgb4i_ddp.c | 678 +++++++++++++
>> drivers/scsi/cxgb4i/cxgb4i_ddp.h | 118 +++
>> drivers/scsi/cxgb4i/cxgb4i_offload.c | 1846
>> ++++++++++++++++++++++++++++++++++
>> drivers/scsi/cxgb4i/cxgb4i_offload.h | 91 ++
>> drivers/scsi/cxgb4i/cxgb4i_snic.c | 260 +++++
>> 6 files changed, 3094 insertions(+), 0 deletions(-)
>> create mode 100644 drivers/scsi/cxgb4i/cxgb4i.h
>> create mode 100644 drivers/scsi/cxgb4i/cxgb4i_ddp.c
>> create mode 100644 drivers/scsi/cxgb4i/cxgb4i_ddp.h
>> create mode 100644 drivers/scsi/cxgb4i/cxgb4i_offload.c
>> create mode 100644 drivers/scsi/cxgb4i/cxgb4i_offload.h
>> create mode 100644 drivers/scsi/cxgb4i/cxgb4i_snic.c
>
>
>
> Got some whitespace errors when applying.
>
> warning: squelched 1 whitespace error
> warning: 6 lines add whitespace errors.
>
>

Oh yeah, run sparse on the driver too. There are some warnings about 
some functions should be static.
