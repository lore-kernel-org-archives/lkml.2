Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab1HaEoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:44:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30719 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1HaEoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:44:10 -0400
Message-ID: <4E5DBBFD.5020202@oracle.com>
Date: Tue, 30 Aug 2011 21:43:41 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110825060632.GA9933@infradead.org> <20110825064039.GO3162@dastard> <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca> <20110826013528.GW3162@dastard> <4E5D8B8E.8030401@oracle.com> <20110831032932.GI32358@dastard>
In-Reply-To: <20110831032932.GI32358@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4E5DBC0A.0089,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/2011 8:29 PM, Dave Chinner wrote:
> And that's -exactly- the ambiguous, vague definition that has raised
> all these questions in the first place. I was in doubt about whether
> unwritten extents can be considered a hole, and by your definition
> that means it should be data. But Andreas seems to be in no doubt it
> should be considered a hole.

Fair enough. Let me rephrase.

Data:
A range in a file when read could return something other than nulls.

Hole:
A range in a file when read only returns nulls.

Considering preallocated extents only return null, they should
be considered holes.


