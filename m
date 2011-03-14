Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab1CNWNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 18:13:34 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58921 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1CNWNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 18:13:33 -0400
Message-ID: <4D7E930A.1010503@cs.wisc.edu>
Date: Mon, 14 Mar 2011 17:13:30 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Open iSCSI <open-iscsi@googlegroups.com>
Subject: Re: [RFC-v2 01/12] iscsi: Resolve iscsi_proto.h naming conflicts
 with drivers/target/iscsi
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>	 <1300103829-10337-2-git-send-email-nab@linux-iscsi.org>	 <20110314145930.GB28480@lst.de> <1300138856.28255.133.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1300138856.28255.133.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2011 04:40 PM, Nicholas A. Bellinger wrote:
> On Mon, 2011-03-14 at 15:59 +0100, Christoph Hellwig wrote:
>> On Mon, Mar 14, 2011 at 04:56:58AM -0700, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger<nab@linux-iscsi.org>
>>>
>>> This patch renames the following iscsi_proto.h structures to avoid
>>> namespace issues with drivers/target/iscsi/iscsi_target_core.h:
>>>
>>> *) struct iscsi_cmd ->  struct iscsi_scsi_cmd
>>
>> This name is not overly descriptive.  Using _req/_rsp uniformly would make a
>> lot more sense.
>>
>
> Mmmm, fair point here..  I don't have a strong preference so I will
> defer to Mike and Hannes on this (open-iscsi CC'ed).  Guys is this OK
> with you..?
>

Ok with me.
