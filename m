Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1DUV3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:29:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48109 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab1DUV3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:29:50 -0400
Message-ID: <4DB0A1C3.6050700@oracle.com>
Date: Thu, 21 Apr 2011 14:29:39 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
In-Reply-To: <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DB0A1C8.0075:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2011 01:45 PM, Theodore Tso wrote:
> On Apr 21, 2011, at 3:42 PM, Josef Bacik wrote:
>> +	case SEEK_DATA:
>> +	case SEEK_HOLE:
>> +		return -EINVAL;
>> 	}
>
> Maybe we should be returning EOPNOTSUPP?
>
> -- Ted

For SEEK_HOLE yes. But we could let the default SEEK_DATA be a null-op.
