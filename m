Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab2AMCrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 21:47:10 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36620 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2AMCrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 21:47:05 -0500
X-AuditID: b753bd60-99661ba00000359c-5f-4f0f9b268e57
X-AuditID: b753bd60-99661ba00000359c-5f-4f0f9b268e57
Message-ID: <4F0F9B1C.3050206@hitachi.com>
Date: Fri, 13 Jan 2012 11:46:52 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH] xfs: show uuid when mount fails due to duplicate
 uuid
References: <20120112024720.3952.73517.stgit@ltc219.sdl.hitachi.co.jp> <20120112161410.GA3810@infradead.org>
In-Reply-To: <20120112161410.GA3810@infradead.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Thank you for your comment.

(2012/01/13 1:14), Christoph Hellwig wrote:
> On Thu, Jan 12, 2012 at 11:47:20AM +0900, Mitsuo Hayasaka wrote:
>> When a system tries to mount a filesystem (FS) using UUID, the xfs
>> returns -EINVAL and shows a message if a FS with the same UUID has
>> been already mounted. It is useful to output the duplicate UUID
>> with it.
> 
> Looks good to me,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
>> -	xfs_warn(mp, "Filesystem has duplicate UUID - can't mount");
>> +	xfs_warn(mp,
>> +		"Filesystem has duplicate UUID - can't mount: uuid = %pU",
>> +		uuid);
> 
> Maybe we could write this a bit nicer as:
> 
> 	xfs_warn(mp, "Filesystem has duplicate UUID %p - can't mount", uuid);
> 

It looks nice.
I will send the revised patch soon.

Thanks.
