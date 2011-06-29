Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab1F2Rkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:40:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41579 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1F2Rkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:40:42 -0400
Message-ID: <4E0B6371.3000104@oracle.com>
Date: Wed, 29 Jun 2011 10:40:01 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: P?draig Brady <P@draigBrady.com>, Dave Chinner <david@fromorbit.com>,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110629065306.GC1026@dastard> <20110629074021.GA26086@infradead.org> <4E0B019E.8080800@draigBrady.com> <4E0B60DE.50908@oracle.com> <20110629173648.GA22293@infradead.org>
In-Reply-To: <20110629173648.GA22293@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E0B638B.0121:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 10:36 AM, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 10:29:02AM -0700, Sunil Mushran wrote:
>> I'm not too sure about that. Atleast not enabled by default. Most users
>> use cp to backup data. Not empty space. In this case, this empty extent
>> may not even be de-dupable.
>>
>> Frankly I'd be happier of cp started to exploited fallocate() to create larger
>> extents before copying data into them. Atleast for the large files.
> That's what delayed allocation is for.

A feature fewer file systems support than fallocate(). ;)
